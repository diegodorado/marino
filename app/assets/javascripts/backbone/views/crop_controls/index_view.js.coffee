Marino.Views.CropControls ||= {}


class NumberFormatter extends Backgrid.NumberFormatter
  decimals: 2
  decimalSeparator: ','
  orderSeparator: ''
  fromRaw: (rawData) ->
    rawData = parseFloat(rawData)
    super(rawData)


class MoneyFormatter extends Backgrid.NumberFormatter
  decimals: 3
  decimalSeparator: ','
  orderSeparator: ''
  fromRaw: (rawData) ->
    rawData = parseFloat(rawData)
    super(rawData)

columns = [
  name: "fecha"
  cell: "date"
  label: "Fecha"
,
  name: "tipo_doc"
  cell: Backgrid.SelectCell.extend( optionValues: [["EX INIC", "EX INIC"], ["CONSUMO", "CONSUMO"], ["COSECHA", "COSECHA"], ["MERMAS", "MERMAS"], ["VENTAS", "VENTAS"]])
  label: "Tipo Doc"      
,
  name: "entrada"
  cell: "number"
  formatter: NumberFormatter
  label: "Entrada Tn"
,
  name: "salida"
  cell: "number"
  formatter: NumberFormatter
  label: "Salida Tn"
,
  name: "saldo"
  cell: "number"
  formatter: NumberFormatter
  editable: false
  label: "Saldo Tn"
,
  name: "precio_unitario"
  cell: "number"
  formatter: MoneyFormatter
  label: "Precio/Tn"
,
  name: "debe"
  cell: "number"
  formatter: MoneyFormatter
  editable: false
  label: "Debe $"
,
  name: "haber"
  cell: "number"
  formatter: MoneyFormatter
  editable: false
  label: "Haber $"
,
  name: "saldo_p"
  cell: "number"
  formatter: MoneyFormatter
  editable: false
  label: "Saldo $"
,
  name: "gestion"
  cell: "boolean"

,
  name: "contabilidad"
  cell: "boolean"
,
  name: "updater_email"
  cell: "email"
  label: "Actualizado por"
  editable: false
,
  name: "comentario"
  cell: "string"
  label: "Comentario"
]




class Marino.Views.CropControls.IndexView extends Backbone.View
  template: JST["backbone/templates/crop_controls/index"]
  el: "#crop_controls"


  events:
    "change .store-filter": "store_filter_changed"
    "click button.add_cc": "add_cc_clicked"
    "click button.delete_cc": "delete_cc_clicked"
    "click button.save": "save_clicked"
    "change input[name=fecha]": "fecha_changed"
    "click .modal button.ok": "modal_ok_clicked"
    "click .modal button.cancel": "modal_cancel_clicked"



  store_filter_changed: (e) ->
    e.preventDefault()
    e.stopPropagation()
    store_id = $(e.target).val()
    models = @shadowCollection.where {store_id: store_id}
    @collection.reset models, {reindex: false}


  add_cc_clicked: (e) ->
    e.preventDefault()
    @$('.modal').modal('show')

    
  delete_cc_clicked: (e) ->
    e.preventDefault()
  save_clicked: (e) ->
    e.preventDefault()
    
  fecha_changed: (e) ->
    e.preventDefault()
    date = $(e.target).val()
    return unless date
    
    
    $.getJSON("/crops/get_price",
      month: date[0..6]
      crop_id: @$(".crop-filter").val() 
    ).done((json) =>
      @$("input[name=precio_unitario]").val(json) 
    ).fail (jqxhr, textStatus, error) ->
      err = textStatus + ", " + error
      console.log "Request Failed: " + err

  modal_ok_clicked: (e) ->
    e.preventDefault()
    @$('.modal').modal('hide')
    params = 
      crop_id: @$(".crop-filter").val() 
      store_id: @$(".store-filter").val() 
      fecha: @$('.modal form input[name=fecha]').val()
      tipo_doc: @$('.modal form select[name=tipo_doc]').val()
      entrada: @$('.modal form input[name=entrada]').val()
      salida: @$('.modal form input[name=salida]').val()
      precio_unitario: @$('.modal form input[name=precio_unitario]').val()
    @collection.add params
  modal_cancel_clicked: (e) ->
    e.preventDefault()
    @$('.modal').modal('hide')





  initialize: () ->
    @collection = @options.crop_controls

    @shadowCollection = @collection.clone()

    @listenTo @collection, "add", (model, collection, options) => @shadowCollection.add(model, options)
    @listenTo @collection, "remove", (model, collection, options) => @shadowCollection.remove(model, options)
    @listenTo @collection, "sort reset", (collection, options) => 
      options = _.extend({reindex: true}, options || {})
      @shadowCollection.reset(collection.models) if (options.reindex) 


  render:  ->
    grid = new Backgrid.Grid
      columns: columns
      collection: @collection

    @$el.html(@template(@options))
    @$("input[name ='fecha']").datepicker({changeMonth:true, changeYear:true, dateFormat: 'yy-mm-dd'})
    @$(".grid").append grid.render().el
    @