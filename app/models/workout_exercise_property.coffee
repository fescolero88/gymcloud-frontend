define [
  'backbone'
], (
  Backbone
) ->

  class WorkoutExerciseProperty extends Backbone.Model

    urlRoot: ->
      wId = @get 'workout_id'
      weId = @get 'workout_exercise_id'
      "/api/mobile/workouts/#{wId}/workout_exercises/#{weId}/properties"

    defaults:
      workout_id: 0,
      workout_exercise_id: 0
      property_id: 0
      property_value: ''
      property_name: ''
      state: 'view'

    toJSON: ->
      _.omit(super, 'state')
