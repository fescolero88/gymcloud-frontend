define [
  'backbone'
], (
  Backbone
) ->

  class Property extends Backbone.Model

    urlRoot: '/personal_properties'

    toJSON: ->
      user: _.pick(super, 'position', 'is_visible')