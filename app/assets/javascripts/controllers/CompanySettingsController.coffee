app = angular.module('company_settings',[
  'templates',
  'ngResource',
  'ngInputModified',
  'ui.bootstrap',
])





app.directive 'contenteditable', ->
  {
    require: 'ngModel'
    link: (scope, elm, attrs, ctrl) ->
      # view -> model
      elm.bind 'blur change', ->
        scope.$apply ->
          ctrl.$setViewValue elm.text().trim()
      # model -> view
      ctrl.$render = ->
        elm.html ctrl.$viewValue
  }




app.directive 'companySettings', ->
  {
    restrict: 'E'
    templateUrl: "company_settings/index.html"
    controller: 'StoresCtrl'
  }

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


app.controller 'StoresCtrl', [
  '$scope',
  'Crop',
  'Store',
  ($scope, Crop, Store) ->
    $scope.crops = Crop.query()
    $scope.stores = Store.query()

    $scope.createStore = ()->
      store = new Store({name:"Deposito #{$scope.stores.length + 1}"})
      store.$save {},  (store)->
        #success
        $scope.stores.push(store)

      , ->
        console.log("error")
        # error
        return


    $scope.updateStore = (store)->
      console.log(store)
      Store.update(store.toJSON())

    $scope.saveChanges = ()->
      for store in $scope.stores
        Store.update(store.toJSON())


    $scope.removeStore = (store)->
      console.log($scope.storeData)
      store.$remove {}, (store)->
        #success
        index = $scope.stores.indexOf(store)
        $scope.stores.splice index, 1

      , (data)->
        console.log(data)
        console.log("error")
        # error
        return



    return
]
