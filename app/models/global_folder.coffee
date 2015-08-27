define [
  'backbone'
], (
  Backbone
) ->

  class GlobalFolder extends Backbone.Model

    url: '/api/mobile/folders'
