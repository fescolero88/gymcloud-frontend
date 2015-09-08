define [
  'backbone'
  'collections/program_workouts'
], (
  Backbone
  ProgramWorkouts
) ->

  class ProgramTemplate extends Backbone.Model

    urlRoot: '/program_templates/'

    validation:
      name:
        required: true

    parse: (data) ->
      @_parseProgramWorkouts(data.workouts) && delete data.workouts
      data

    _parseProgramWorkouts: (exercises) ->
      @program_workouts ||= new ProgramWorkouts
      @program_workouts.add(exercises, parse: true, merge: true)