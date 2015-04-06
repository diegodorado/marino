angular
  .module('app')
  .controller 'CropPricesCtrl', [
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
