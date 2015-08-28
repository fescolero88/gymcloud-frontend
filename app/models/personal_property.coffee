define [
  'backbone'
], (
  Backbone
) ->

  class Property extends Backbone.Model

    urlRoot: '/personal_properties'