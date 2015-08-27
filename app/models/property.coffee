define [
  'backbone'
], (
  Backbone
) ->

  class Property extends Backbone.Model

    urlRoot: '/api/mobile/properties'

    validation:

      name:
        required: true

      defaultvalue: (val, attr, computed) ->
        if !val.length
          return
        valueType = computed.value_type
        if valueType == 'Numeric'
          return Backbone.Validation.validators.pattern(val, attr, 'digits', this)
