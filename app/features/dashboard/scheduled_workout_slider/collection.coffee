define [
  'models/workout_event'
], (
  WorkoutEvent
) ->

  class WorkoutEventCollection extends Backbone.Collection

    model: WorkoutEvent

    url: ->
      userId = @options?.user_id or App.request('current_user_id')
      "/users/#{userId}/collections/workout_events"
