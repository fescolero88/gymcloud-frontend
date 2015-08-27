define [
  'backbone'
  'models/property'
], (
  Backbone
  Property
) ->

  class ClientsProperties extends Backbone.Collection

    urlRoot: '/api/mobile'

    model: Property
