Backbone = require 'backbone'

module.exports = class GlobalWorkoutModel extends Backbone.Model
  urlRoot: '/api/mobile/workouts/'
