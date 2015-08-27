define [
  'backbone'
  'models/property'
], (
  Backbone
  Property
) ->

  class Properties extends Backbone.Collection

    url: '/api/mobile/properties'

    model: Property
