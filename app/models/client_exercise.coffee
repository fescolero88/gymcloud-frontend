define [
  'backbone'
], (
  Backbone
) ->

  class ClientExercise extends Backbone.Model

    urlRoot: '/api/mobile'
