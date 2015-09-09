define [
  './workout_template'
  './personal_workout'
], (
  WorkoutTemplate
  PersonalWorkout
) ->

  class ProgramWorkout extends Backbone.Model

    urlRoot: '/program_workouts/'

    parse: (data) ->
      @_parseWorkout(data.workout, data.workout_type) && delete data.workout
      data

    _parseWorkout: (workout, type) ->
      Workout = {
        WorkoutTemplate: WorkoutTemplate
        PersonalWorkout: PersonalWorkout
      }[type]
      @workout ||= new Workout(workout, parse: true)
      if type is 'WorkoutTemplate'
        collection = App.request('current_user').workout_templates
        collection.add(@workout)
