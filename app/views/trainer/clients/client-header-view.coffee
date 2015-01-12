Marionette = require 'backbone.marionette'

module.exports = class ClientHeaderView extends Marionette.ItemView
  template: Templates.trainer.clients.client_header

  modelEvents:
    "sync": "render"
