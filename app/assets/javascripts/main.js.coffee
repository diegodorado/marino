#= require_self

data = [
  id: 0
  date: "2011-01-01"
  x: 1
  entrada: 2
  salida: 3
  country: "DE"
  geo:
    lat: 52.56
    lon: 13.40
,
  id: 1
  date: "2011-02-02"
  x: 2
  entrada: 4
  salida: 24
  country: "UK"
  geo:
    lat: 54.97
    lon: -1.60
,
  id: 2
  date: "2011-03-03"
  x: 3
  entrada: 6
  salida: 9
  country: "US"
  geo:
    lat: 40.00
    lon: -75.5
,
  id: 3
  date: "2011-04-04"
  x: 4
  entrada: 8
  salida: 6
  country: "UK"
  geo:
    lat: 57.27
    lon: -6.20
,
  id: 4
  date: "2011-05-04"
  x: 5
  entrada: 10
  salida: 15
  country: "UK"
  geo:
    lat: 51.58
    lon: 0
,
  id: 5
  date: "2011-06-02"
  x: 6
  entrada: 12
  salida: 18
  country: "DE"
  geo:
    lat: 51.04
    lon: 7.9
]



class Application
  constructor: ->
    @utils = 
      num_to_s: (num) ->
        num = num + ''
        num = '0' + num if num.length is 1
        num
    @options = {}
    
  load: (options) ->
    for key, val of options
      @options[key] = val
      
  start: ->
    $ => @onReadyLoad()
  
  onReadyLoad: ->
    #set users
    @user_id = @options.user_id

    if @options.backups
      dataset = new recline.Model.Dataset
        records: @options.backups
        backend: 'rest'

      dataset.fetch()

      $el = $("#grid")
      grid = new recline.View.SlickGrid(
        model: dataset
        el: $el
        state:
          hiddenColumns: ["id", "user_id"]        
          gridOptions:
            editable: true

          columnsEditor: [
            column: "title"
            editor: Slick.Editors.Text,
            column: "x"
            editor: Slick.Editors.Integer
          ]
      )
      grid.visible = true
      grid.render()    
      app.grid= grid

      onChange = ->
        dataset.save().done (o)->
          console.log 'hurra!', o
        $(".ex-events").append "Queried: " + dataset.queryState.get("q") + ". Records matching: " + dataset.recordCount
        $(".ex-events").append "<br />"

      dataset.records.bind "change", onChange

      $('#commit').on 'click', ->
        dataset.save().done (o...)->
          console.log 'commited!', o

      $('#test').on 'click', ->
        dataset.fetch().done (o...)->
          console.log 'fetch!', o

  
    if @options.grid
      dataset = new recline.Model.Dataset(records: data)

      virtual_field = new recline.Model.Field(
        format: null
        id: "saldo"
        is_derived: true
        label: "saldo"
        type: "string"
      ,
        deriver: (val, field, record) ->
          record.collection.filter((r) ->
            record.collection.indexOf(r) <= r.collection.indexOf(record)
          ).reduce ((memo, r) ->
            memo + r.get("entrada") - r.get("salida")
          ), 0
      )
      dataset.fields.push virtual_field

      $el = $("#mygrid")
      grid = new recline.View.SlickGrid(
        model: dataset
        el: $el
        state:
          hiddenColumns: ["x", "geo", "country"]
          columnsWidth: [
            column: "id"
            width: 250
          ]
          gridOptions:
            editable: true

          columnsEditor: [
            column: "country"
            editor: Slick.Editors.Text
          ,
            column: "date"
            editor: Slick.Editors.Date
          ,
            column: "entrada"
            editor: Slick.Editors.Integer
          ]
      )
      grid.visible = true
      grid.render()    



window.app = new Application  
