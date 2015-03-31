angular
  .module('app')
  .controller 'CropControlListCtrl', [
    '$scope',
    '$filter',
    'Crop',
    'Store',
    'CropControl',
    'ngTableParams',
    ($scope, $filter, Crop, Store, CropControl, ngTableParams) ->
      $scope.filters =
        gestion: 0
        contabilidad: 1
      $scope.crop_controls = []
      $scope.$data = []

      $scope.crops = Crop.query ->
        $scope.stores = Store.query ->
          $scope.filters.crop_id = $scope.crops[0]._id
          $scope.filters.store_id = $scope.stores[0]._id
          $scope.reQuery()

      $scope.reQuery = ()->
        $scope.crop_controls = CropControl.query $scope.filters , ->
          $scope.tableParams.$params.page = 1
          $scope.tableParams.total($scope.crop_controls.length)
          $scope.tableParams.reload()

      $scope.gestion = ()->
        return if $scope.filters.gestion
        $scope.filters.gestion = 1
        $scope.filters.contabilidad = 0
        $scope.reQuery()

      $scope.contabilidad = ()->
        return if $scope.filters.contabilidad
        $scope.filters.gestion = 0
        $scope.filters.contabilidad = 1
        $scope.reQuery()

      $scope.excel = () ->
        window.location = "/api/crop_controls.xlsx?store_id=#{$scope.filters.store_id}&crop_id=#{$scope.filters.crop_id}&gestion=#{$scope.filters.gestion}&contabilidad=#{$scope.filters.contabilidad}"


      $scope.tableParams = new ngTableParams {
        page: 1
        count: 10
      },{
        total: ->
          $scope.crop_controls.length
        getData: ($defer, params) ->
          $defer.resolve $scope.crop_controls.slice((params.page() - 1) * params.count(), params.page() * params.count())
      }



      return
  ]
