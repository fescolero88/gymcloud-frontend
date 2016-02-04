define [
  'pages/personal_programs/overview/page'
], (
  PersonalProgramsOverviewPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:
      'personal_programs/:id': 'overview'

  class Controller extends Marionette.Controller

    overview: (id, state) ->
      new PersonalProgramsOverviewPage
        id: id
        state: 'overview'

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
