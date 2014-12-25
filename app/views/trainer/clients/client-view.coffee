Marionette = require 'backbone.marionette'
myTemplate = require '../../../templates/trainer/clients/client'

module.exports = class ClientView extends Marionette.LayoutView
  template: myTemplate

  regions:
    'header': '#client-header-region'
    'nav': '#client-content-nav-region'
    'leftside': '#client-left-region'
    'rightside': '#client-right-region'
