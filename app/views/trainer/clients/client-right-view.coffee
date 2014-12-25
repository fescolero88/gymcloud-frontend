Marionette = require 'backbone.marionette'
myTemplate = require '../../../templates/trainer/clients/client-right'

module.exports = class ClientRightView extends Marionette.ItemView
  template: myTemplate
