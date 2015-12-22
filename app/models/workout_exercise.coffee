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

    initialize: ->
      @listenTo(@, 'change:order_name', @_syncOrderName)
      @_syncOrderName()
      @

    changedAttributes: ->
      result = super
      if _.isObject(result)
        result = _.omit(result, [
          'order_number'
          'order_letter'
        ]...)
      if _.isEmpty(result) then false else result

    parse: (data) ->
      @properties ||= new ExerciseProperties
      if @properties.length is 0
        @properties.add(data.exercise_properties, parse: true)
      delete data.exercise_properties
      data

    _syncOrderName: ->
      value = "#{@get('order_name') || ''}"
      re = /^([a-z]{1,2})(\d{1,2})$/i
      match = value.match(re)
      @set
        order_letter: match?[1] || '~'
        order_number: match?[2]
