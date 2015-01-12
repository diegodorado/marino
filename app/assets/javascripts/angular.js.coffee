receta = angular.module('receta',[
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
])

receta.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'RecipesController'
      )
])

controllers = angular.module('controllers',[])

angular.module("todoApp", []).controller "TodoController", [
  "$scope"
  ($scope) ->
    $scope.todos = [
      {
        text: "learn angular"
        done: true
      }
      {
        text: "build an angular app"
        done: false
      }
    ]
    $scope.addTodo = ->
      $scope.todos.push
        text: $scope.todoText
        done: false

      $scope.todoText = ""
      return

    $scope.remaining = ->
      count = 0
      angular.forEach $scope.todos, (todo) ->
        count += (if todo.done then 0 else 1)
        return

      count

    $scope.archive = ->
      oldTodos = $scope.todos
      $scope.todos = []
      angular.forEach oldTodos, (todo) ->
        $scope.todos.push todo  unless todo.done
        return

      return
]

angular.bootstrap(document.getElementById("receta"),['receta']);
angular.bootstrap(document.getElementById("todoApp"),['todoApp']);
