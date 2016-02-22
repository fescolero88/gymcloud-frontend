define [
  'backbone-nested'
], ->

  class PersonalProperty extends Backbone.NestedModel

    type: 'PersonalProperty'

    urlRoot: '/personal_properties'
