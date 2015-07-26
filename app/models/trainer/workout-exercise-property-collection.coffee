Backbone = require 'backbone'
WorkoutExercisePropertyModel = require 'models/trainer/workout-exercise-property-model'

module.exports = class WorkoutExercisePropertyCollection extends Backbone.Collection

  model: WorkoutExercisePropertyModel
  
