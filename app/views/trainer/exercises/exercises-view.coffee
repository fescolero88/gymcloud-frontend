Marionette = require 'backbone.marionette'

module.exports = class ExercisesView extends Marionette.ItemView

  template: ->
    if Math.round(Math.random())
        Templates.trainer.exercises.exercises
    else
        Templates.trainer.exercises.exercises_empty
