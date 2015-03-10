Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class AddExerciseModalView extends Marionette.ItemView
  className: 'modal-dialog modal-md'
  template: Templates.trainer.exercises.add_exercise_modal
