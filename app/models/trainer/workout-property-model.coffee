Backbone = require 'backbone'

module.exports = class WorkoutPropertyModel extends Backbone.Model

  url: ->
    "/api/mobile/workouts/#{@get 'workout_id'}/workout_exercises/#{@get 'workout_exercise_id'}/properties"

  defaults:
    workout_id: 0,
    workout_exercise_id: 0
    property_id: 0
    property_value: ''
    state: 'view'
