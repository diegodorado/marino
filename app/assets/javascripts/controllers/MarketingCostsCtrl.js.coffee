angular.module('app').controller 'MarketingCostsCtrl', [
  '$scope',
  'Crop',
  'Store',
  ($scope, Crop, Store) ->
    $scope.crops = Crop.query()
    $scope.stores = Store.query()

    $scope.updateStore = (store)->
      Store.update(store.toJSON())

    return
]
