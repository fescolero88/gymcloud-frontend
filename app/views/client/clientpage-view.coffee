Marionette = require 'backbone.marionette'

module.exports = class ClientPageView extends Marionette.LayoutView

  template: Templates.client.clientpage

  regions:
    nav: '#clientpage-nav-region'
    content: '#clientpage-content-region'
