Marionette = require 'backbone.marionette'

module.exports = class MainView extends Marionette.LayoutView
  template: Templates.general.base
  el: 'body'

  regions:
    appRegion: 'region[data-name="app"]'
