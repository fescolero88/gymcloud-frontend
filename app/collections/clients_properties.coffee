define [
  'models/property'
], (
  Property
) ->

  class ClientsProperties extends Backbone.Collection

    urlRoot: '/api/mobile'

    model: Property
