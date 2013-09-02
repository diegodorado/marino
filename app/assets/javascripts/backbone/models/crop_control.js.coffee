class Marino.Models.CropControl extends Backbone.Model
  paramRoot: 'crop_control'

  defaults:
    entrada: 0
    salida: 0
    precio_unitario: 0
    gestion: true
    contabilidad: true
    tipo_doc: 'EX INIC'

  tipo_docs: ['EX INIC','COSECHA','AJUSTE +','VENTAS','MERMAS','CONSUMOS','SEMILLA','AJUSTE -']

  isEntrada: () ->
    @get('tipo_doc') in ['EX INIC','COSECHA','AJUSTE +']

  isSalida: () ->
    @get('tipo_doc') in ['VENTAS','MERMAS','CONSUMOS','SEMILLA','AJUSTE -']

  toJSON: ()->
    attrs = super()
    attrs['tipo_docs'] = @tipo_docs
    attrs
    

    


class Marino.Collections.CropControlsCollection extends Backbone.Collection
  model: Marino.Models.CropControl
  url: '/crop_controls'

  params: {}
  
  precio_unitario: ()->
    models = @where @params
    _.last(models).get('precio_unitario')

  comparator: (model) ->
    model.get("fecha")

  calculate: ()->
    models = @where @params
    models = _.invoke(models, 'toJSON');
    saldo = 0
    saldo_p = 0
    _.each models, (item) ->
      saldo += item.entrada-item.salida
      item.saldo = Math.round(saldo * 1000) / 1000
      item.debe = Math.round(item.entrada*item.precio_unitario * 1000) / 1000
      item.haber = Math.round(item.salida*item.precio_unitario * 1000) / 1000
      saldo_p += item.debe-item.haber
      item.saldo_p = Math.round(saldo_p * 1000) / 1000
    models