define [
  'collections/exercise_properties'
], (
  ExerciseProperties
) ->

  class WorkoutsExercise extends Backbone.Model

    type: 'WorkoutsExercise'

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
