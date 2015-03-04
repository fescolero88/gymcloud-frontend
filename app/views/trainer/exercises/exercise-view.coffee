Marionette = require 'backbone.marionette'

module.exports = class ExerciseView extends Marionette.ItemView

  template: Templates.trainer.exercises.exercise

  modelEvents:
    "sync": "render"
    "change": "render"
