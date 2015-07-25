Backbone = require 'backbone'

module.exports = class WorkoutExercisePropertyModel extends Backbone.Model

  urlRoot: ->
    "/api/mobile/workouts/#{@get 'workout_id'}/workout_exercises/#{@get 'workout_exercise_id'}/properties"

  defaults:
    workout_id: 0,
    workout_exercise_id: 0
    property_id: 0
    property_value: ''
    property_name: ''
    state: 'view'

  toJSON: ->
    property_value: @get 'property_value'
    property_id: @get 'property_id'
    property_name: @get 'property_name'
