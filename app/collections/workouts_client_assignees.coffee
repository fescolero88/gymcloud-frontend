define [
  'backbone'
], (
  Backbone
) ->

  class WorkoutClientAssignees extends Backbone.Collection

    url: ->
      "/api/mobile/workouts/#{@id}/assignees"
