angular
  .module('app')
  .controller 'CropControlSummaryCtrl', [
    '$scope',
    '$http',
    '$filter',
    ($scope, $http, $filter) ->
      $scope.crops = []

      $scope.getTotalGestion = ()->
        total = 0
        for crop in $scope.crops
          total += crop.tn_gest*crop.unit_gest
        total

      $scope.getTotalContabilidad = ()->
        total = 0
        for crop in $scope.crops
          total += crop.tn_cont*crop.unit_cont
        total

      $scope.selectDate = (dt) ->
        dt = $filter('date')(dt, 'yyyy-MM-dd')
        return unless dt?

        $scope.balance_at = dt
        $http.get('/api/crop_controls/summary.json?balance_at='+dt)
          .then( (res) ->
           $scope.crops = res.data;
        )

      $scope.selectDate(new Date())

      $scope.open = ($event) ->
        $event.preventDefault()
        $event.stopPropagation()
        $scope.opened = true
        return

      $scope.dateOptions =
        formatYear: 'yy'
        startingDay: 1
        showWeeks: 0


      return
  ]
