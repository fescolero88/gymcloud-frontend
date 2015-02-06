Marionette = require 'backbone.marionette'

module.exports = class MainView extends Marionette.LayoutView
  template: Templates.general.base
  el: 'body'

  regions:
    appRegion: 'region[data-name="app"]'

  ui:
    'appRegion': 'region[data-name="app"]'

  initialize: =>
    App.vent.on 'body:change-class', @changeClass

  onDestroy: =>
    App.vent.off 'body:change-class', @changeClass

  show: ->
    @ui.appRegion.removeClass('hide')

  changeClass: (className) =>
    @$el.removeClass().addClass className

