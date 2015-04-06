angular.module('app').controller 'StoresCtrl', [
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
