define [
  'backbone'
  'lodash'
  './workout_exercise'
], (
  Backbone
  _
  WorkoutExercise
) ->
  Exercises = Backbone.Collection.extend(model: WorkoutExercise)

  class WorkoutTemplate extends Backbone.Model

    urlRoot: '/workout_templates/'

    validation:

      name:
        required: true

    parse: (data) ->
      @exercises ||= new Exercises
      if @exercises.length is 0
        @exercises.add(data.exercises, parse: true)
      delete data.exercises
      data