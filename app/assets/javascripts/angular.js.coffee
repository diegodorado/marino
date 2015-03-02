app = angular.module('marinoApp',[
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


app.controller 'CropsCtrl', [
  '$scope',
  'Crop',
  ($scope, Crop) ->
    $scope.crops = Crop.query()

    $scope.createCrop = ()->
      crop = new Crop({name:"Grano #{$scope.crops.length + 1}"})
      crop.$save {},  (crop)->
        #success
        $scope.crops.push(crop)
      , ->
        console.log("error")
        # error
        return

    $scope.updateCrop = (crop)->
      Crop.update(crop.toJSON())

    $scope.removeCrop = (crop)->
      crop.$remove {}, (crop)->
        #success
        index = $scope.crops.indexOf(crop)
        $scope.crops.splice index, 1
      , (data)->
        # error
        console.log(data)
        console.log("error")

    return
]






app.controller 'CropPricesCtrl', [
  '$scope',
  'Crop',
  ($scope, Crop) ->
    $scope.crops = Crop.query()
    $scope.year = new Date().getFullYear()
    $scope.months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun','Jul','Ago','Sep','Oct','Nov','Dic']

    $scope.updateCrop = (crop)->
      Crop.update(crop.toJSON())

    $scope.previousYear = ()->
      $scope.year--
    $scope.nextYear = ()->
      $scope.year++

    return
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




app.controller 'MarketingCostsCtrl', [
  '$scope',
  'Crop',
  'Store',
  ($scope, Crop, Store) ->
    $scope.crops = Crop.query()
    $scope.stores = Store.query()

    $scope.updateStore = (store)->
      console.log store
      Store.update(store.toJSON())

    $scope.saveChanges = ()->
      for store in $scope.stores
        Store.update(store.toJSON())

    return
]
