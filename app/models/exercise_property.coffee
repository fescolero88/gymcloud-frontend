define [
  'backbone'
  './personal_property'
], (
  Backbone
  PersonalProperty
) ->

  class ExerciseProperty extends Backbone.Model

    urlRoot: '/exercise_properties'

    parse: (data) ->
      attrs = data.personal_property
      @personal_property = new PersonalProperty(attrs, parse: true)
      data.personal_property = @personal_property.attributes
      data.personal_property_id = @personal_property.get('id')
      data