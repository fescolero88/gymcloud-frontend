define [
  'pages/personal_workouts/overview/page'
], (
  PersonalWorkoutOverviewPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:
      'personal_workouts/:id': 'overview'

  class Controller extends Marionette.Controller

    overview: (id, state) ->
      new PersonalWorkoutOverviewPage
        id: id
        state: 'overview'

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
