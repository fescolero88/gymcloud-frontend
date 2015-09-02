define [
  'backbone'
  'models/client'
], (
  Backbone
  Client
) ->

  class Clients extends Backbone.Collection

    model: Client

    url: '/users'
