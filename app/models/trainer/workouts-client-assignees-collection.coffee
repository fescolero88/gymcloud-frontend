Backbone = require 'backbone'

module.exports = class WorkoutClientAssigneesCollection extends Backbone.Collection

  url: ->
    "/api/mobile/workouts/#{@id}/assignees"
