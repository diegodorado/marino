app = angular.module('app',[
  'templates',
  'ngResource',
  'ngInputModified',
  'ui.bootstrap',
])


app.factory 'Store', [
  '$resource',
  ($resource) ->
    $resource '/api/stores/:id.json', {id: '@_id'}, update: method: 'PUT'
]

app.factory 'Crop', [
  '$resource',
  ($resource) ->
    $resource '/api/crops/:id.json', {id: '@_id'}, update: method: 'PUT'
]
