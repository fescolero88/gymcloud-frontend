define [
  './concerns/nested_models'
  'collections/program_workouts'
], (
  NestedModelsConcern
  ProgramWorkouts
) ->

  class ProgramWeek extends Backbone.Model

    type: 'ProgramWeek'

    urlRoot: '/program_weeks/'

    defaults:
      name: undefined
      program_id: undefined
      position: undefined

    constructor: ->
      @_nestedModelsInit
        program_workouts: ProgramWorkouts
      super

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

    setPosition: (pos) ->
      @save({
        position: pos
        name: "Week #{pos}"
      }, wait: true)

  _.extend(ProgramWeek::, NestedModelsConcern)

  ProgramWeek
