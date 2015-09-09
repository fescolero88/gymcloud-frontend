define [
  'models/client'
], (
  Client
) ->

  class Clients extends Backbone.Collection

    model: Client
    url: '/users'
