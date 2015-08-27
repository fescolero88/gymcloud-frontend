define [
  'backbone'
], (
  Backbone
) ->

  class WorkoutExercises extends Backbone.Collection

    urlRoot: '/api/mobile'
