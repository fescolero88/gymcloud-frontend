define [
  'pages/trainer_dashboard/page'
], (
  TrainerDashboard
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'trainer_dashboard(/)': 'root'

  class Controller extends Marionette.Controller

    root: ->
      new TrainerDashboard

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller