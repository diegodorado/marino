app = angular.module('company_settings',[
  'templates',
  'ngResource',
])



app.directive 'companySettings', ->
  {
    restrict: 'E'
    templateUrl: "company_settings/index.html"
    controller: ->
      @tab = 1

      @isSet = (checkTab) ->
        @tab == checkTab

      @setTab = (setTab) ->
        @tab = setTab
        return

      return
    controllerAs: 'tab'
  }
