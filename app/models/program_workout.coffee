define [
  './concerns/nested_models'
  './workout_template'
  './personal_workout'
], (
  NestedModelsConcern
  WorkoutTemplate
  PersonalWorkout
) ->

  class ProgramWorkout extends Backbone.Model

    type: 'ProgramWorkout'

    urlRoot: '/program_workouts/'

    constructor: ->
      @_nestedModelsInit
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
