define [
  'backbone'
  'models/program_workout'
], (
  Backbone
  ProgramWorkout
) ->

  class ProgramWorkouts extends Backbone.Collection

    model: ProgramWorkout
