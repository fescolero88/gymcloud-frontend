Marionette = require 'backbone.marionette'

module.exports = class ClientPageActivityView extends Marionette.ItemView

  template: Templates.client.clientpage_activity

  collectionEvents:
    sync: 'render'
