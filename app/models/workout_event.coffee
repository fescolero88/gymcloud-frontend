define [
  './concerns/nested_models'
  'collections/workout_event_exercises'
  'features/event_results/comments/collection'
], (
  NestedModelsConcern
  WorkoutEventExercises
  Comments
) ->

  class WorkoutsEvent extends Backbone.Model

    type: 'WorkoutsEvent'

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

  _.extend(WorkoutsEvent::, NestedModelsConcern)

  WorkoutsEvent