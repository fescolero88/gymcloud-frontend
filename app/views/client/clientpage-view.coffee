Marionette = require 'backbone.marionette'
myTemplate = require '../../templates/client/clientpage'

module.exports = class ClientPageView extends Marionette.LayoutView
  template: myTemplate

  regions:
    'nav': '#clientpage-nav-region'
    'content': '#clientpage-content-region'
