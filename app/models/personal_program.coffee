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
      @weeks.personal_program = @
      @workouts.personal_program = @
      super

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

  _.extend(PersonalProgram::, NestedModelsConcern)

  PersonalProgram