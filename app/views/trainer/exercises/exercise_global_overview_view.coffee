Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class ExerciseGlobalOverviewView extends Marionette.ItemView
  template: Templates.trainer.exercises.exercise_global_overview
  tagname: 'div'
  className: 'gc-exercises-exercise-view'
