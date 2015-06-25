Marionette = require 'backbone.marionette'

UiView = require 'views/prototype/ui-view'

module.exports =

  ui: ->
    view = new UiView
    App.baseView.appRegion.show(view)