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
      $scope.crop_control =  null

      $scope.$data = []

      $scope.crops = Crop.query ->
        $scope.stores = Store.query ->
          $scope.filters.crop_id = $scope.crops[0]._id
          $scope.filters.store_id = $scope.stores[0]._id
          $scope.reQuery()

      $scope.reQuery = ()->
        $scope.crop_controls = CropControl.query $scope.filters , ->
          $scope.tableParams.$params.page = Math.ceil($scope.crop_controls.length/$scope.tableParams.$params.count)
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
        window.location = "/crop_controls/index.xlsx?store_id=#{$scope.filters.store_id}&crop_id=#{$scope.filters.crop_id}&gestion=#{$scope.filters.gestion}&contabilidad=#{$scope.filters.contabilidad}"


      $scope.tableParams = new ngTableParams {
        page: 1
        count: 10
      },{
        total: ->
          $scope.crop_controls.length
        getData: ($defer, params) ->
          $defer.resolve $scope.crop_controls.slice((params.page() - 1) * params.count(), params.page() * params.count())
      }


      #form functions

      $scope.datePickerOpen = ($event) ->
        $event.preventDefault()
        $event.stopPropagation()
        $scope.datePickerOpened = true
        return

      $scope.dateOptions =
        formatYear: "yy"
        startingDay: 1
        showWeeks: 0

      $scope.newCropControl = () ->
        defaults=
          entrada: 0
          salida: 0
          gestion: true
          contabilidad: true
          tipo_doc: 'EX INIC'
          crop_id: $scope.filters.crop_id
          store_id: $scope.filters.store_id
          fecha: $filter('date')(new Date, 'yyyy-MM-dd')

        $scope.crop_control =  new CropControl(defaults)
        return

      $scope.editCropControl = (cc) ->
        $scope.crop_control =  cc

      $scope.destroyCropControl = (cc) ->
        cc.$delete ->
          $scope.reQuery()


      $scope.cancel = () ->
        $scope.crop_control =  null



      $scope.save = () ->
        $scope.crop_control.$save ({crop_control: $scope.crop_control})->
          $scope.crop_control =  null
          $scope.reQuery()


      $scope.saveAndAdd = () ->
        $scope.crop_control.$save ({crop_control: $scope.crop_control})->
          $scope.reQuery()
          $scope.newCropControl()


      return
  ]
