define [
  './concerns/nested_models'
  './workout_template'
  './personal_workout'
  './program_template'
  './personal_program'
], (
  NestedModelsConcern
  WorkoutTemplate
  PersonalWorkout
  ProgramTemplate
  PersonalProgram
) ->

  class ProgramWorkout extends Backbone.Model

    type: 'ProgramWorkout'

    urlRoot: '/program_workouts/'

    constructor: ->
      @_nestedModelsInit
        program:
          polymorphicKey: 'program_type'
          polymorphicModels:
            ProgramTemplate: ProgramTemplate
            PersonalProgram: PersonalProgram
        workout:
          polymorphicKey: 'workout_type'
          polymorphicModels:
            WorkoutTemplate: WorkoutTemplate
            PersonalWorkout: PersonalWorkout
      super

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

  _.extend(ProgramWorkout::, NestedModelsConcern)

  ProgramWorkout
