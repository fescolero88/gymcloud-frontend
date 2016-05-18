define [
  'pages/workout_enter_result/page'
], (
  WorkoutEnterResultPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'workout_enter_result(/)': 'root'

  class Controller extends Marionette.Controller

    root: ->
      new WorkoutEnterResultPage

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
