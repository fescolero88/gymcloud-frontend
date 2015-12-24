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
        workout: WorkoutTemplate
      super

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

    # parse: (data) ->
    #   @_parseWorkout(data.workout, data.workout_type) && delete data.workout
    #   data

    _parseWorkout: (workout, type) ->
      Workout = {
        WorkoutTemplate: WorkoutTemplate
        PersonalWorkout: PersonalWorkout
      }[type]
      @workout ||= new Workout(workout, parse: true)
      if type is 'WorkoutTemplate'
        collection = App.request('current_user').workout_templates
        collection.add(@workout, merge: true)

  _.extend(ProgramWorkout::, NestedModelsConcern)

  ProgramWorkout
