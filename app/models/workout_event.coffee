define [
  './concerns/nested_models'
  'collections/workout_event_exercises'
], (
  NestedModelsConcern
  WorkoutEventExercises
) ->

  class WorkoutsEvent extends Backbone.Model

    type: 'WorkoutsEvent'

    url: -> "/workout_events/#{@id}/full"

    constructor: ->
      @_nestedModelsInit
        exercises: WorkoutEventExercises
      super

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

  _.extend(WorkoutsEvent::, NestedModelsConcern)

  WorkoutsEvent