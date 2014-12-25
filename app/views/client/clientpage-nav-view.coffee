Marionette = require 'backbone.marionette'
myTemplate = require '../../templates/client/nav'

module.exports = class ClientPageNavView extends Marionette.ItemView
  template: myTemplate
