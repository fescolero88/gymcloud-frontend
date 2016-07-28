define [
  'pages/client_dashboard/page'
], (
  TrainerDashboard
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'client_dashboard(/)': 'root'

  class Controller extends Marionette.Controller

    root: ->
      new TrainerDashboard

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller