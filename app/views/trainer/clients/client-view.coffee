Marionette = require 'backbone.marionette'

module.exports = class ClientView extends Marionette.LayoutView
  template: require '../../../templates/trainer/clients/client'

  regions:
    'header': '#client-header-region'
    'nav': '#client-content-nav-region'
    'leftside': '#client-left-region'
    'rightside': '#client-right-region'
