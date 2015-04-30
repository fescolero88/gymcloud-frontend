Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class WorkoutGlobalExercisesView extends Marionette.ItemView
  template: Templates.trainer.workouts.workout_global_video
  className: 'gc-workouts-video-view'

