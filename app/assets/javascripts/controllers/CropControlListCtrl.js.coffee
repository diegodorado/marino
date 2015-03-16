angular
  .module('app')
  .controller 'CropControlListCtrl', [
    '$scope',
    '$http',
    '$filter',
    ($scope, $http, $filter) ->
      $scope.crop_controls = []

      $http.get('/api/crop_controls/index.json')
        .then( (res) ->
         $scope.crop_controls = res.data;
      )


      return
  ]
