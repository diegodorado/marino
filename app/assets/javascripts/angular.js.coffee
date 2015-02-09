app = angular.module('marinoApp',[
  'templates',
  'ngResource',
  'ngInputModified',
  'ui.bootstrap',
])


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
    $scope.year = new Date().getFullYear()
    $scope.months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun','Jul','Ago','Sep','Oct','Nov','Dic']

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
      console.log(crop)
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


    $scope.previousYear = ()->
      $scope.year--
    $scope.nextYear = ()->
      $scope.year++



    return
]
