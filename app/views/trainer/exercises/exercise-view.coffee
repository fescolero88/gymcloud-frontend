Marionette = require 'backbone.marionette'

module.exports = class ExerciseView extends Marionette.ItemView
  template: Templates.trainer.exercises.exercises
