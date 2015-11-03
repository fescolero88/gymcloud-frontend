define [
  'models/workout_exercise'
], (
  WorkoutExercise
) ->

  class WorkoutExercises extends Backbone.Collection

    type: 'WorkoutExercises'

    model: WorkoutExercise

    addExercise: (args = {}) ->
      attrs = _.pick args, [
        'exercise_id'
        'workout_id'
      ]...
      model = new @model(attrs)
      model.save()
        .then =>
          @add(model)
