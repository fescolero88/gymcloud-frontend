define [
  'backbone'
], (
  Backbone
) ->

  class PersonalProperty extends Backbone.Model

    urlRoot: '/personal_properties'