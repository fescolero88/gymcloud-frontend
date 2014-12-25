Marionette = require 'backbone.marionette'
myTemplate = require '../../../templates/trainer/clients/client-compact-header'

module.exports = class ClientCompactHeaderView extends Marionette.ItemView
  template: myTemplate
