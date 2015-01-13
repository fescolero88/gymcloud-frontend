Marionette = require 'backbone.marionette'

module.exports = class ExercisesView extends Marionette.ItemView

  template: ->
    Templates.trainer.exercises.exercises
