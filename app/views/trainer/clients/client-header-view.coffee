Marionette = require 'backbone.marionette'
myTemplate = require '../../../templates/trainer/clients/client-header'

module.exports = class ClientHeaderView extends Marionette.ItemView
  template: myTemplate
