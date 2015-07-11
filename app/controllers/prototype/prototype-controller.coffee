define [
  'views/prototype/ui-view'
], (
  UiView
) ->

  ui: ->
    view = new UiView
    App.baseView.appRegion.show(view)
