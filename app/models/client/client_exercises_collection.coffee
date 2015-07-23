Backbone = require 'backbone'

module.exports = class ClientExercisesCollection extends Backbone.Collection

  url: '/api/mobile/me/exercises'