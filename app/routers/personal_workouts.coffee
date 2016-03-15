define [
  'pages/personal_workouts/overview/page'
  'pages/personal_workouts/edit/page'
], (
  PersonalWorkoutOverviewPage
  PersonalWorkoutEditPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:
      'personal_workouts/:id': 'overview'
      'personal_workouts/:id/edit': 'edit'

  class Controller extends Marionette.Controller

    overview: (id, state) ->
      new PersonalWorkoutOverviewPage
        id: id
        state: 'overview'
    edit: (id, state) ->
      new PersonalWorkoutEditPage
        id: id
        state: 'edit'

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
