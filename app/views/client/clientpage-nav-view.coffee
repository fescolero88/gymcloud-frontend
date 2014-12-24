Marionette = require 'backbone.marionette'

module.exports = class ClientPageNavView extends Marionette.ItemView
  template: require '../../templates/client/nav'
