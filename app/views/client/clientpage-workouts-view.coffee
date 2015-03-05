Marionette = require 'backbone.marionette'

module.exports = class WorkoutsView extends Marionette.ItemView

  template: Templates.client.workouts

  collectionEvents:
    sync: 'render'
