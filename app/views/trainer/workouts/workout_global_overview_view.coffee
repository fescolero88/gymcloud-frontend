Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class WorkoutGlobalOverviewView extends Marionette.LayoutView
  template: Templates.trainer.workouts.workout_global_overview
  className: 'gc-workouts-workout-view'
