class RemoteModel
  constructor: (@base_url) ->
    @onFetched = new Slick.Event()
    @onCreated = new Slick.Event()
    @onUpdated = new Slick.Event()
    @onDeleted = new Slick.Event()

    @request = null

  getItems: ->
    if @request
      @request.abort()

    @request = $.ajax
      url: "#{@base_url}.json"
      dataType: 'json'
      cache: false
      success: (response) =>
        @request = null
        @onFetched.notify({data: response})

  createItem: (item) ->
    $.ajax
      url: "#{@base_url}.json"
      type: 'POST'
      data: item
      dataType: 'json'
      success: (response) =>
        @onCreated.notify
          item: response

  updateItem: (item) ->
    $.ajax
      url: "#{@base_url}/#{item.id}.json"
      type: 'PUT'
      data: item
      dataType: 'json'
      success: (response) =>
        @onUpdated.notify
          item: response

  deleteItem: (item) ->
    $.ajax
      url: "#{@base_url}/#{item.id}.json"
      type: 'DELETE'
      dataType: 'json'
      success: (response) =>
        @onDeleted.notify
          item: item


$.extend(true, window, {
  "Slick": {
    "Data": {
      "RemoteModel": RemoteModel
    }
  }
})
