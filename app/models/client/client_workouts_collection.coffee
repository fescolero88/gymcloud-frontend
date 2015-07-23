Backbone = require 'backbone'

module.exports = class ClientWorkoutsCollection extends Backbone.Collection

  url: '/api/mobile/me/workouts'