angular.module('app').controller 'CropsCtrl', [
  '$scope',
  'Crop',
  ($scope, Crop) ->
    $scope.crops = Crop.query()

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

    return
]
