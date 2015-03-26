angular
  .module('app')
  .controller 'CropControlListCtrl', [
    '$scope',
    '$filter',
    'Crop',
    'Store',
    'CropControl',
    ($scope, $filter, Crop, Store, CropControl) ->
      $scope.filters =
        gestion: 0
        contabilidad: 1

      $scope.crops = Crop.query ->
        $scope.stores = Store.query ->
          $scope.crop_id = $scope.crops[0]._id
          $scope.store_id = $scope.stores[0]._id
          $scope.reQuery()

      $scope.reQuery = ()->
        $scope.crop_controls = CropControl.query($scope.filters)

      $scope.gestion = ()->
        $scope.gestion = 1
        $scope.contabilidad = 0
        #$scope.reQuery()

      $scope.contabilidad = ()->
        $scope.gestion = 0
        $scope.contabilidad = 1
        #$scope.reQuery()

      return
  ]
