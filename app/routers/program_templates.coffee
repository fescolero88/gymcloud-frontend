define [
  'pages/program_templates/overview/page'
  'features/programs/constructor/view'
], (
  ProgramTemplateOverviewPage
  ProgramConstructorView
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'program_templates/:id': 'root'
      'program_templates/:id/:state': 'overview'
      #'program_templates/:id(/)': 'programConstructor'

  class Controller extends Marionette.Controller

    root: (id) ->
      path = "program_templates/#{id}/overview"
      App.vent.trigger('redirect:to', path)

    overview: (id, state) ->
      new ProgramTemplateOverviewPage
        id: id
        state: state

    programConstructor: (id) ->
      user = App.request('current_user')
      collection = user.program_templates
      model = collection.get(id)

      model.fetch().then =>
        view = new ProgramConstructorView
          model: model
        @_showView(view)

    _showView: (view) ->
      App.request('views:show', view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
