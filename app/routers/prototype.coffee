define [
  'views/prototype/ui-view'
  'views/prototype/render_template'
], (
  UiView
  TemplateRenderer
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'prototype/ui': 'ui'
      'prototype/template/:templateName': 'renderTemplate'

  class Controller extends Marionette.Controller

    ui: ->
      view = new UiView
      App.baseView.appRegion.show(view)

    renderTemplate: (templateName) ->
      view = new TemplateRenderer(templateName)
      App.baseView.appRegion.show(view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
