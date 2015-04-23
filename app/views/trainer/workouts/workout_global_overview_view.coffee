Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

WorkoutGlobalExercisesView = require 'views/trainer/workouts/workout_global_exercises_view'
WorkoutExercisesCollection = require 'models/trainer/workout_exercises_collection'

module.exports = class WorkoutGlobalOverviewView extends Marionette.LayoutView
  template: Templates.trainer.workouts.workout_global_overview
  className: 'gc-workouts-workout-view'

  regions:
    exercisesListRegion: '#gc-exercises-list-region'

  initialize: (data) =>
    @workoutModel = data.model
    exercisesCollection = new WorkoutExercisesCollection
    @exercisesView = new WorkoutGlobalExercisesView collection: exercisesCollection, workout: @workoutModel

  onShow: =>
    @exercisesListRegion.show @exercisesView
