define [
  'backbone'
  'models/workout_exercise_property'
], (
  Backbone
  WorkoutExerciseProperty
) ->

  class WorkoutExerciseProperties extends Backbone.Collection

    model: WorkoutExerciseProperty
