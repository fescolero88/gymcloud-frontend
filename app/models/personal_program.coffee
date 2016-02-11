define [
  './concerns/nested_models'
  './personal_workout'
  'collections/program_workouts'
  'collections/program_weeks'
], (
  NestedModelsConcern
  PersonalWorkout
  ProgramWorkouts
  ProgramWeeks
) ->

  class PersonalProgram extends Backbone.Model

    type: 'PersonalProgram'

    urlRoot: '/personal_programs'

    constructor: ->
      @_nestedModelsInit
        weeks: ProgramWeeks
        workouts: ProgramWorkouts
      @weeks.program = @
      @workouts.program = @
      super

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

  _.extend(PersonalProgram::, NestedModelsConcern)

  PersonalProgram