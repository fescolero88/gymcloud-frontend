Marionette = require 'backbone.marionette'

module.exports = class ExercisesView extends Marionette.ItemView

  template: Templates.client.exercises

  collectionEvents:
    "sync": "render"
