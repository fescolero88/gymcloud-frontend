Marionette = require 'backbone.marionette'

module.exports = class ClientPageSidebarView extends Marionette.ItemView
  template: require '../../templates/client/sidebar'
