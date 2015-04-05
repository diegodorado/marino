app = angular.module('app',[
  'templates',
  'ngResource',
  'ngInputModified',
  'ui.bootstrap',
  'ngTable',
])



app.factory 'Resource', [
  '$resource'
  ($resource) ->
    (url, params, methods) ->
      defaults =
        update:
          method: 'put'
          isArray: false
        create: method: 'post'
      defaultsParams =
        id: '@_id'
      params = angular.extend(defaultsParams, params)
      methods = angular.extend(defaults, methods)
      resource = $resource(url, params, methods)

      resource::$save = (args)->
        if !@_id
          @$create(args)
        else
          @$update( args)

      resource
]


app.factory 'Store', [
  'Resource',
  ($resource) ->
    $resource '/api/stores/:id.json'
]

app.factory 'Crop', [
  'Resource',
  ($resource) ->
    $resource '/api/crops/:id.json'
]

app.factory 'CropControl', [
  'Resource',
  ($resource) ->
    CropControl = $resource '/api/crop_controls/:id.json'

    CropControl::canValuate= () ->
      return @tipo_doc in ['VALUACION','EX INIC','COSECHA']

    CropControl::isEntrada= () ->
      return @tipo_doc in ['EX INIC','COSECHA','AJUSTE +','ALQUILER +','APARCERIA +']

    CropControl::isSalida= () ->
      return @tipo_doc in ['VENTAS','MERMAS','CONSUMOS','SEMILLA','AJUSTE -','ALQUILER -','APARCERIA -']

    CropControl::tipoDocs= () ->
      return ['EX INIC','COSECHA','AJUSTE +','ALQUILER +','APARCERIA +','VENTAS','MERMAS','CONSUMOS','SEMILLA','AJUSTE -','ALQUILER -','APARCERIA -', 'VALUACION']

    CropControl

]
