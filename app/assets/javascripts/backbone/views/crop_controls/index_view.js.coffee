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


  render:  ->
    #console.log @options.crop_controls.models[0]
    grid = new Backgrid.Grid
      columns: columns
      collection: @options.crop_controls

    @$el.html(@template())
    @$(".grid").append grid.render().el
    @