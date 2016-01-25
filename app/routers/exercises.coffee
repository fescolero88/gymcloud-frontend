define [
  'pages/exercises/overview/page'
], (
  ExerciseOverviewPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'exercises': 'toFolder'
      'exercises/:id': 'root'
      'exercises/:id/:state': 'overview'

  class Controller extends Marionette.Controller

    toFolder: ->
      user = App.request('current_user')
      id = user.folders.findWhere(name: 'Exercises').get('id')
      path = "exercises_folder/#{id}"
      App.vent.trigger('redirect:to', path)

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
