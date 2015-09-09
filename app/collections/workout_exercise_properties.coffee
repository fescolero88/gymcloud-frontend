define [
  'models/workout_exercise_property'
], (
  WorkoutExerciseProperty
) ->

  class WorkoutExerciseProperties extends Backbone.Collection

    model: WorkoutExerciseProperty
