define [
  'backbone'
], (
  Backbone
) ->

  class GlobalExercise extends Backbone.Model

    urlRoot: '/api/mobile/exercises/'

    validation:

      name:
        required: true

      description:
        required: false
