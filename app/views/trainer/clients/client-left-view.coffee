Marionette = require 'backbone.marionette'
myTemplate = require '../../../templates/trainer/clients/client-left'

module.exports = class ClientLeftView extends Marionette.ItemView
  template: myTemplate
