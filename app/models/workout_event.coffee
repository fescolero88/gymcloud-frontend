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


    computed: ->
      begins_at_int:
        depends: ['begins_at']
        get: (attrs) ->
          moment(attrs.begins_at).valueOf()
        toJSON: false
      ends_at_int:
        depends: ['ends_at', 'begins_at']
        get: (attrs) ->
          if attrs.ends_at
            moment(attrs.ends_at)
          else
            moment(attrs.begins_at).add(1, 'day')
        toJSON: false

    constructor: ->
      @_nestedModelsInit
        exercises: WorkoutEventExercises
        comments: Comments
      @comments.workout_event = @
      super

    initialize: ->
      @computedFields = new Backbone.ComputedFields(@)

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

    finish: ->
      @save({is_completed: true}, wait: true)

  _.extend(WorkoutEvent::, NestedModelsConcern)

  WorkoutEvent