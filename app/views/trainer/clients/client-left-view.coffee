Marionette = require 'backbone.marionette'

module.exports = class ClientLeftView extends Marionette.ItemView
  template: require '../../../templates/trainer/clients/client-left'
