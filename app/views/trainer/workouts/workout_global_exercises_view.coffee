Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

class EmptyView extends Marionette.ItemView
  template: Templates.trainer.workouts.workout_global_exercises_empty

class ExercisesItemView extends Marionette.ItemView
  tagName: 'li'
  template: Templates.trainer.workouts.workout_global_exercise_item



module.exports = class WorkoutGlobalExercisesView extends Marionette.CompositeView
  template: Templates.trainer.workouts.workout_global_exercises
  className: 'gc-workouts-exercises-view'
  emptyView: EmptyView
  childView: ExercisesItemView
  childViewContainer: 'ul'

  templateHelpers: =>
    workout: @workout.attributes

  initialize: (data) =>
    @workout = data.workout
