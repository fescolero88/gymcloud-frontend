define [
  'views/prototype/ui-view'
  'views/prototype/render_template'
], (
  UiView
  TemplateRenderer
) ->

  ui: ->
    view = new UiView
    App.baseView.appRegion.show(view)

  renderTemplate: (templateName) ->
    view = new TemplateRenderer templateName
    App.appRegion.show(view)
