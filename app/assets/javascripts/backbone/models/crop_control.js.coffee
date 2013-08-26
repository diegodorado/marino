class Marino.Models.CropControl extends Backbone.Model
  paramRoot: 'crop_control'

  defaults:
    entrada: 0
    debe: 0
    haber: 0
    gestion: true
    contabilidad: true

class Marino.Collections.CropControlsCollection extends Backbone.Collection
  model: Marino.Models.CropControl
  url: '/crop_controls'

  params: {}

  calculate: ()->
    models = @where @params
    models = _.invoke(models, 'toJSON');
    saldo = 0
    saldo_p = 0
    _.each models, (item) ->
      saldo += item.entrada-item.salida
      item.saldo = saldo
      item.debe = item.entrada*item.precio_unitario
      item.haber = item.salida*item.precio_unitario
      saldo_p += item.debe-item.haber
      item.saldo_p = saldo_p
    models