app = angular.module('company_settings',[
  'templates',
  'ngResource',
])



app.directive 'companySettings', ->
  {
    restrict: 'E'
    templateUrl: "company_settings/index.html"
    controller: 'StoresCtrl'
    controllerAs: 'tab'
  }

app.factory 'Store', [
  '$resource',
  ($resource) ->
    $resource '/api/stores/:id.json', {id: '@_id'}
]

app.controller 'StoresCtrl', [
  '$scope',
  'Store',
  ($scope, Store) ->
    $scope.stores = Store.query()
    $scope.update = (store)->
      Store.save(store)
    return
]
