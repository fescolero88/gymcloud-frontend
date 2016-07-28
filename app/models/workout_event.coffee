define [
  './concerns/nested_models'
  'collections/workout_event_exercises'
  'features/event_results/comments/collection'
], (
  NestedModelsConcern
  WorkoutEventExercises
  Comments
) ->

  class WorkoutEvent extends Backbone.Model

    type: 'WorkoutEvent'

    url: -> "/workout_events/#{@id}/full"

    constructor: ->
      @_nestedModelsInit
        exercises: WorkoutEventExercises
        comments: Comments
      @comments.workout_event = @
      super

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

    finish: ->
      @save({is_completed: true}, wait: true)

  _.extend(WorkoutEvent::, NestedModelsConcern)

  WorkoutEvent