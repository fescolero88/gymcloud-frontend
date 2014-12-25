Marionette = require 'backbone.marionette'
myTemplate = require '../../templates/client/sidebar'

module.exports = class ClientPageSidebarView extends Marionette.ItemView
  template: myTemplate
