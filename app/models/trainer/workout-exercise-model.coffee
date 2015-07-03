Backbone = require 'backbone'

module.exports = class WorkoutsExercise extends Backbone.Model

  urlRoot: '/api/mobile/workouts'

  validation:

    id:
      required: true

    workout_exercise_id:
      required: false

  sync: (method, model, options) ->
    if @addExercise
      Backbone.sync('create', model, options)
    else
      Backbone.sync(method, model, options)