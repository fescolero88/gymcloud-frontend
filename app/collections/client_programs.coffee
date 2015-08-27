define [
  'backbone'
], (
  Backbone
) ->

  class ClientPrograms extends Backbone.Collection

    url: '/api/mobile/me/programs'
