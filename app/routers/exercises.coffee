define [
  'pages/exercises/overview/page'
], (
  ExerciseOverviewPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'exercises/:id': 'root'
      'exercises/:id/:state': 'overview'

  class Controller extends Marionette.Controller

    root: (id) ->
      path = "exercises/#{id}/overview"
      App.vent.trigger('redirect:to', path)

    overview: (id, state) ->
      new ExerciseOverviewPage
        id: id
        state: state

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
