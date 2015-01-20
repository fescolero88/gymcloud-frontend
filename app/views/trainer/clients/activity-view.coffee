Marionette = require 'backbone.marionette'

module.exports = class ActivityView extends Marionette.ItemView
  template: Templates.trainer.clients.activity

  collectionEvents:
    "sync": "render"

