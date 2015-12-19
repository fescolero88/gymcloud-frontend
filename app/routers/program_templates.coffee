define [
  'pages/program_templates/overview/page'
], (
  ProgramTemplateOverviewPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'program_templates/:id': 'root'
      'program_templates/:id/:state': 'overview'

  class Controller extends Marionette.Controller

    root: (id) ->
      path = "program_templates/#{id}/overview"
      App.vent.trigger('redirect:to', path)

    overview: (id, state) ->
      new ProgramTemplateOverviewPage
        id: id
        state: state

    _showView: (view) ->
      App.request('views:show', view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
