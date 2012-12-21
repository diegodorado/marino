@recline or= {}
@recline.Backend or= {}
my = @recline.Backend.Rest or= {}
$ = jQuery


my.__type__ = "rest"

  
class my.RestWrapper
  
  constructor: (@db_url, @view_url, @options) ->
    @endpoint = @db_url
    @view_url ||= @db_url + "/" + "_all_docs"
    @options = _.extend(
      dataType: "json"
    , @options)

  _makeRequest: (data, headers) ->
    extras = {}
    if headers
      extras = beforeSend: (req) ->
        _.each headers, (value, key) ->
          req.setRequestHeader key, value

    data = _.extend(extras, data)
    $.ajax data

  mapping: ->
    schemaUrl = @view_url + "?limit=1&include_docs=true"
    schemaUrl = "/backups.json"
    jqxhr = @_makeRequest(
      url: schemaUrl
      dataType: @options.dataType
    )
    jqxhr

  get: (_id) ->
    base = @endpoint + "/" + _id
    base = "/backups/#{_id}.json"
    @_makeRequest
      url: base
      dataType: "json"


  upsert: (doc) ->
    data = JSON.stringify(doc)
    #data = doc
    url = @endpoint
    url += "/" + doc._id  if doc._id
    url = "/backups/#{doc._id}.json"
    @_makeRequest
      url: url
      type: "PUT"
      data: data
      dataType: "json"
      contentType: "application/json"


  remove: (_id) ->
    url = @endpoint
    url += "/" + _id
    @_makeRequest
      url: url
      type: "DELETE"
      dataType: "json"


  _normalizeQuery: (queryObj) ->
    out = (if queryObj and queryObj.toJSON then queryObj.toJSON() else _.extend({}, queryObj))
    delete out.sort

    delete out.query

    delete out.filters

    delete out.fields

    delete out.facets

    out["skip"] = out.from or 0
    out["limit"] = out.size or 100
    delete out.from

    delete out.size

    out["include_docs"] = true
    out

  query: (query_object, query_options={}) ->
    norm_q = @_normalizeQuery(query_object)
    url = @view_url
    url = "/backups.json"    
    q = _.extend(query_options, norm_q)
    console.log norm_q, q
    jqxhr = @_makeRequest(
      url: url
      data: q
      dataType: @options.dataType
    )
    jqxhr

my.couchOptions = {}
my.fetch = (dataset) ->
  db_url = dataset.db_url
  view_url = dataset.view_url
  cdb =  new my.RestWrapper(db_url, view_url)
  dfd = $.Deferred()
  cdb.mapping().done((result) ->
    dfd.resolve records: result
  ).fail (arguments_) ->
    dfd.reject arguments_

  dfd.promise()

my.save = (changes, dataset) ->
  dfd = $.Deferred()
  total = changes.creates.length + changes.updates.length + changes.deletes.length
  results =
    done: []
    fail: []

  decr_cb = ->
    total -= 1

  resolve_cb = ->
    dfd.resolve results  if total is 0

  for i of changes.creates
    new_doc = changes.creates[i]
    succ_cb = (msg) ->
      results.done.push
        op: "create"
        record: new_doc
        reason: ""


    fail_cb = (msg) ->
      results.fail.push
        op: "create"
        record: new_doc
        reason: msg


    _createDocument(new_doc, dataset).then [decr_cb, succ_cb, resolve_cb], [decr_cb, fail_cb, resolve_cb]
  for i of changes.updates
    new_doc = changes.updates[i]
    succ_cb = (msg) ->
      results.done.push
        op: "update"
        record: new_doc
        reason: ""


    fail_cb = (msg) ->
      results.fail.push
        op: "update"
        record: new_doc
        reason: msg


    _updateDocument(new_doc, dataset).then [decr_cb, succ_cb, resolve_cb], [decr_cb, fail_cb, resolve_cb]
  for i of changes.deletes
    old_doc = changes.deletes[i]
    succ_cb = (msg) ->
      results.done.push
        op: "delete"
        record: old_doc
        reason: ""


    fail_cb = (msg) ->
      results.fail.push
        op: "delete"
        record: old_doc
        reason: msg


    _deleteDocument(new_doc, dataset).then [decr_cb, succ_cb, resolve_cb], [decr_cb, fail_cb, resolve_cb]
  dfd.promise()

my.query = (queryObj, dataset) ->
  dfd = $.Deferred()
  db_url = dataset.db_url
  view_url = dataset.view_url
  query_options = dataset.query_options
  cdb = new my.RestWrapper(db_url, view_url)
  cdb_q = cdb._normalizeQuery(queryObj, query_options)
  cdb.query(queryObj, query_options).done (records) ->
    query_result =
      hits: []
      total: 0

    _.each records, (record) ->
      query_result.total += 1
      query_result.hits.push record

    query_result.hits = _applyFilters(query_result.hits, queryObj)
    query_result.hits = _applyFreeTextQuery(query_result.hits, queryObj)
    _.each queryObj.sort, (sortObj) ->
      fieldName = sortObj.field
      query_result.hits = _.sortBy(query_result.hits, (doc) ->
        _out = doc[fieldName]
        _out
      )
      query_result.hits.reverse()  if sortObj.order is "desc"

    query_result.total = query_result.hits.length
    query_result.facets = _computeFacets(query_result.hits, queryObj)
    query_result.hits = query_result.hits.slice(cdb_q.skip, cdb_q.skip + cdb_q.limit + 1)
    dfd.resolve query_result

  dfd.promise()

_applyFilters = (results, queryObj) ->
  getDataParser = (filter) ->
    fieldType = "string"
    dataParsers[fieldType]
  term = (record, filter) ->
    parse = getDataParser(filter)
    value = parse(record[filter.field])
    term = parse(filter.term)
    value is term
  range = (record, filter) ->
    startnull = (not filter.start? or filter.start is "")
    stopnull = (not filter.stop? or filter.stop is "")
    parse = getDataParser(filter)
    value = parse(record[filter.field])
    start = parse(filter.start)
    stop = parse(filter.stop)
    return false  if (not startnull or not stopnull) and value is ""
    (startnull or value >= start) and (stopnull or value <= stop)
  geo_distance = ->
  filters = queryObj.filters
  filterFunctions =
    term: term
    range: range
    geo_distance: geo_distance

  dataParsers =
    integer: (e) ->
      parseFloat e, 10

    float: (e) ->
      parseFloat e, 10

    string: (e) ->
      e.toString()

    date: (e) ->
      new Date(e).valueOf()

    datetime: (e) ->
      new Date(e).valueOf()

  return _.filter(results, (record) ->
    passes = _.map(filters, (filter) ->
      filterFunctions[filter.type] record, filter
    )
    _.all passes, _.identity
  )

_applyFreeTextQuery = (results, queryObj) ->
  if queryObj.q
    terms = queryObj.q.split(" ")
    results = _.filter(results, (rawdoc) ->
      matches = true
      _.each terms, (term) ->
        foundmatch = false
        _.each _.keys(rawdoc), (field) ->
          value = rawdoc[field]
          value = value.toString()  if value isnt null
          foundmatch = foundmatch or (value is term)

        matches = matches and foundmatch

      matches
    )
  results

_computeFacets = (records, queryObj) ->
  facetResults = {}
  return facetResults  unless queryObj.facets
  _.each queryObj.facets, (query, facetId) ->
    facetResults[facetId] = new recline.Model.Facet(id: facetId).toJSON()
    facetResults[facetId].termsall = {}

  _.each records, (doc) ->
    _.each queryObj.facets, (query, facetId) ->
      fieldId = query.terms.field
      val = doc[fieldId]
      tmp = facetResults[facetId]
      if val
        tmp.termsall[val] = (if tmp.termsall[val] then tmp.termsall[val] + 1 else 1)
      else
        tmp.missing = tmp.missing + 1


  _.each queryObj.facets, (query, facetId) ->
    tmp = facetResults[facetId]
    terms = _.map(tmp.termsall, (count, term) ->
      term: term
      count: count
    )
    tmp.terms = _.sortBy(terms, (item) ->
      -item.count
    )
    tmp.terms = tmp.terms.slice(0, 10)

  facetResults

_createDocument = (new_doc, dataset) ->
  dfd = $.Deferred()
  db_url = dataset.db_url
  view_url = dataset.view_url
  _id = new_doc["id"]
  cdb = new my.RestWrapper(db_url, view_url)
  delete new_doc["id"]

  new_doc = dataset.record_create(new_doc)  if dataset.record_create
  if _id isnt 1 and _id isnt `undefined`
    new_doc["_id"] = _id
  else
    new_doc["_id"] = randomId(32, "#a")
  dfd.resolve cdb.upsert(new_doc)
  dfd.promise()

_updateDocument = (new_doc, dataset) ->
  dfd = $.Deferred()
  db_url = dataset.db_url
  view_url = dataset.view_url
  _id = new_doc["id"]
  cdb = new my.RestWrapper(db_url, view_url)
  delete new_doc["id"]


  jqxhr = cdb.get(_id)
  jqxhr.done((old_doc) ->
    new_doc = dataset.record_update(new_doc, old_doc)  if dataset.record_update
    new_doc = _.extend(old_doc, new_doc)
    new_doc["_id"] = _id
    dfd.resolve cdb.upsert(new_doc)
  ).fail (args) ->
    dfd.reject args

  dfd.promise()

_deleteDocument = (del_doc, dataset) ->
  dfd = $.Deferred()
  db_url = dataset.db_url
  view_url = dataset.view_url
  _id = del_doc["id"]
  cdb = new my.RestWrapper(db_url, view_url)
  unless view_url.search("_all_docs") isnt -1
    _id = model.get("_id").split("__")[0]
    jqxhr = cdb.get(_id)
    # XXX is this the right thing to do?
    
    # couchdb uses _id to identify documents, Backbone models use id.
    # we should remove it before sending it to the server.
    jqxhr.done((old_doc) ->
      old_doc = dataset.record_delete(del_doc, old_doc)  if dataset.record_delete
      unless _.isNull(del_doc)
        old_doc["_id"] = _id
        delete old_doc["id"]

        dfd.resolve cdb.upsert(old_doc)
    ).fail (args) ->
      dfd.reject args

    dfd.promise()
