angular.module('app').controller 'MarketingCostsCtrl', [
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
