Backbone = require 'backbone'
ProgramWorkoutModel = require 'models/trainer/program-workout-model'

module.exports = class ProgramWorkoutCollection extends Backbone.Collection

  model: ProgramWorkoutModel
