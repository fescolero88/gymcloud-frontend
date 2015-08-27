define [
  'backbone'
], (
  Backbone
) ->

  class Program extends Backbone.Model

    url: '/api/mobile/programs'
