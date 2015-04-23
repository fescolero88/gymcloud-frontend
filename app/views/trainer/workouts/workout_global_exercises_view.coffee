Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

class EmptyView extends Marionette.ItemView
  template: Templates.trainer.workouts.workout_global_exercises_empty

module.exports = class WorkoutGlobalExercisesView extends Marionette.CompositeView
  template: Templates.trainer.workouts.workout_global_exercises
  className: 'gc-workouts-exercises-view'
  emptyView: EmptyView
  childViewContainer: 'ul'

  templateHelpers: =>
    workout: @workout.attributes

  initialize: (data) =>
    @workout = data.workout
