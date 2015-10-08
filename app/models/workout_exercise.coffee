define [
  './exercise_property'
], (
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

    orderLetter: ->
      orderName = @get('order_name')
      letter = orderName?.match(/[a-zA-z]+/)?[0]
      letter || "~#{orderName}"

    orderNumber: ->
      @get('order_name')?.match(/\d+/)?[0]

    parse: (data) ->
      @properties ||= new ExerciseProperties
      if @properties.length is 0
        @properties.add(data.exercise_properties, parse: true)
      delete data.exercise_properties
      data

    updatePosition: (pos) ->
      @set('position', pos)
      @save()