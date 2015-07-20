Backbone = require 'backbone'
WorkoutPropertyModel = require 'models/trainer/workout-property-model'

module.exports = class WorkoutPropertyCollection extends Backbone.Collection

  model: WorkoutPropertyModel
  
