Backbone = require 'backbone'

module.exports = class WorkoutsExercise extends Backbone.Model

  urlRoot: '/api/mobile/workouts'

  validation:

    id:
      required: true

    workout_exercise_id:
      required: false
