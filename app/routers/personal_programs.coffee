define [
  'pages/personal_programs/overview/page'
  'pages/personal_programs/edit/page'
], (
  PersonalProgramsOverviewPage
  PersonalProgramsEditPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:
      'personal_programs/:id': 'overview'
      'personal_programs/:id/edit': 'edit'

  class Controller extends Marionette.Controller

    overview: (id, state) ->
      new PersonalProgramsOverviewPage
        id: id
        state: 'overview'
    edit: (id, state) ->
      new PersonalProgramsEditPage
        id: id
        state: 'edit'

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
