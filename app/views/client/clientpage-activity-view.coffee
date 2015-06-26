Marionette = require 'backbone.marionette'

module.exports = class ClientPageActivityView extends Marionette.ItemView

  template: require('templates/client/clientpage_activity')

  collectionEvents:
    sync: 'render'
