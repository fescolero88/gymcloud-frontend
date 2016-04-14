define [
  './concerns/nested_models'
  './personal_property'
  'mathjs'
], (
  NestedModelsConcern
  PersonalProperty
  mathjs
) ->

  class ExerciseProperty extends Backbone.Model

    type: 'ExerciseProperty'

    urlRoot: '/exercise_properties'

    computed: ->
      round = (value, decimals) ->
        Number(Math.round(value + 'e' + decimals) + 'e-' + decimals)

      get = (name, attrs) ->
        if !attrs[name] or
          _.include([0, 1], @personal_property.property_units.length) or
          !@get('property_unit_id')

            return round(attrs[name], 2)

        saveUnit = @personal_property.get('save_unit').short_name
        unit = mathjs.unit("#{attrs[name]} #{saveUnit}")
        value = unit.toNumber(@get('property_unit_name'))
        round(value, 2)

      set = (name, value, attrs) ->
        if !value or
          _.include([0, 1], @personal_property.property_units.length) or
          !@get('property_unit_id')

            return attrs[name] = round(value, 2) || null

        saveUnit = @personal_property.get('save_unit').short_name
        unit = mathjs.unit("#{value} #{@get('property_unit_name')}")
        newValue = unit.toNumber(saveUnit)
        attrs[name] = round(newValue, 2) || null

      value_converted:
        depends: ['personal_property', 'property_unit_name', 'value']
        get: _.bind(get, @, 'value')
        set: _.bind(set, @, 'value')
        toJSON: false

      value2_converted:
        depends: ['personal_property', 'property_unit_name', 'value2']
        get: _.bind(get, @, 'value2')
        set: _.bind(set, @, 'value2')
        toJSON: false

    validation:

      property_unit_id:
        required: true

      personal_property_id:
        required: true

      workout_exercise_id:
        required: true

    constructor: ->
      @_nestedModelsInit
        personal_property: PersonalProperty
      super

    initialize: ->
      @computedFields = new Backbone.ComputedFields(@)

    parse: (data) ->
      attrs = data.personal_property
      @_nestedModelsParseAll(data)
      data.personal_property = attrs
      data.personal_property_id = attrs.id
      data

    setUnit: (property_unit) ->
      @set
        property_unit_id: property_unit.get('id')
        property_unit_name: property_unit.get('short_name')

    setProperty: (personal_property) ->
      unless @get('personal_property_id')
        value = @get('value')
        value2 = @get('value2')

      default_unit = personal_property.get('default_unit')
      @personal_property = personal_property
      @set
        personal_property_id: personal_property.id
        personal_property: personal_property.attributes
        property_name: personal_property.get('name')
        value: value or null
        value2: value2 or null
        property_unit_id: default_unit.id
        property_unit_name: default_unit.short_name

  _.extend(ExerciseProperty::, NestedModelsConcern)

  ExerciseProperty