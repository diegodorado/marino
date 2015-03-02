class Marino.Models.CropControl extends Backbone.Model
  paramRoot: 'crop_control'
  idAttribute: '_id'
  

  defaults:
    entrada: 0
    salida: 0
    precio_unitario: 0
    gestion: true
    contabilidad: true
    tipo_doc: 'EX INIC'

  isValuacion: () ->
    @get('tipo_doc') in ['VALUACION']

  isEntrada: () ->
    @get('tipo_doc') in ['EX INIC','COSECHA','AJUSTE +','ALQUILER +','APARCERIA +']

  isSalida: () ->
    @get('tipo_doc') in ['VENTAS','MERMAS','CONSUMOS','SEMILLA','AJUSTE -','ALQUILER -','APARCERIA -']
  
  tn: () ->
    parseFloat(@get('entrada')) - parseFloat(@get('salida'))
  unit: () ->
    parseFloat(@get('precio_unitario'))

class Marino.Collections.CropControlsCollection extends Backbone.Collection
  model: Marino.Models.CropControl
  url: '/crop_controls'

  params: {}
  tipo_docs: ['EX INIC','COSECHA','AJUSTE +','ALQUILER +','APARCERIA +','VENTAS','MERMAS','CONSUMOS','SEMILLA','AJUSTE -','ALQUILER -','APARCERIA -', 'VALUACION']
  
  precio_unitario: ()->
    models = @where @params
    last = _.last(models)
    if last
      last.get('precio_unitario')
    else
      0

  comparator: (model) ->
    model.get("fecha")

  filteredIds: ()->
    models = @where @params
    _.pluck(models, 'id')
 
  calculate: ()->
    models = @where @params
    models = _.invoke(models, 'toJSON')
    precio_anterior = 0
    saldo = 0
    saldo_p = 0
    _.each models, (item) ->
      saldo += item.entrada-item.salida
      item.saldo = Math.round(saldo * 1000) / 1000

      if item.tipo_doc is 'VALUACION'
        
        #=F17*E17-F16*E16
        cant =  (item.precio_unitario  - precio_anterior) * saldo
        if cant >= 0
          item.debe = cant
          item.haber = 0
        else
          item.debe = 0
          item.haber = -cant
          
      else
        item.debe = item.entrada*item.precio_unitario
        item.haber = item.salida*item.precio_unitario
        
      saldo_p += item.debe-item.haber
      item.saldo_p = saldo_p
      #watch out! first item cant be valuacion
      precio_anterior = item.precio_unitario

      
    models
