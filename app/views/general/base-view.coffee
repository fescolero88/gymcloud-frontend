Marionette = require 'backbone.marionette'

module.exports = class BaseView extends Marionette.LayoutView
  template: Templates.general.base
  el: 'body'

  regions:
    appRegion: 'region[data-name="app"]'

  ui:
    'appRegion': 'region[data-name="app"]'

  show: ->
    @ui.appRegion.removeClass('hide')

