define [
  'models/workout_event'
], (
  WorkoutEvent
) ->

  class WorkoutEventCollection extends Backbone.Collection

    model: WorkoutEvent
