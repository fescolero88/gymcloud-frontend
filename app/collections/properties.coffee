define [
  'models/property'
], (
  Property
) ->

  class Properties extends Backbone.Collection

    url: '/api/mobile/properties'

    model: Property
