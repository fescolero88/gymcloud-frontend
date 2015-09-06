define [
  'backbone'
  './exercise_property'
], (
  Backbone
  ExerciseProperty
) ->
  ExerciseProperties = Backbone.Collection.extend(model: ExerciseProperty)

  class WorkoutsExercise extends Backbone.Model

    urlRoot: '/workout_exercises'

    validation:

      name:
        required: true

      workout_id:
        required: true

      exercise_id:
        required: true

    parse: (data) ->
      @properties ||= new ExerciseProperties
      if @properties.length is 0
        @properties.add(data.exercise_properties, parse: true)
      delete data.exercise_properties
      data