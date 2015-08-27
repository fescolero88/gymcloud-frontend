define [
  'backbone'
], (
  Backbone
) ->

  class WorkoutsExercise extends Backbone.Model

    urlRoot: '/api/mobile/workouts'

    validation:

      id:
        required: true

      workout_exercise_id:
        required: false

    sync: (method, model, options) ->
      if @method
        Backbone.sync(@method, model, options)
      else
        Backbone.sync(method, model, options)
