Marionette = require 'backbone.marionette'

module.exports = class ClientHeaderView extends Marionette.ItemView
  template: require '../../../templates/trainer/clients/client-header'
