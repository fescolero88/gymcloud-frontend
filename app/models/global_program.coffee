define [
  'backbone'
], (
  Backbone
) ->

  class GlobalProgram extends Backbone.Model

    urlRoot: '/api/mobile/programs/'
