define [
  'features/properties/select_box/view'
  'features/property_unit_selector/view'
], (
  PropertiesSelectBox
  PropertyUnitSelectorCollectionView
) ->

  class EditableExercisePropertyBehavior extends Marionette.Behavior

    key: 'editable_exercise_property'

    behaviors:

      regioned:
        views: [
            region: 'properties_select_box'
            klass: PropertiesSelectBox
            options: ->
              property = if @model.isNew()
                name: 'Select property'
                global_property:
                  unit: ''
              else
                @model.get('personal_property')

              default_property: property
          ,
            region: 'property_unit_selector'
            klass: PropertyUnitSelectorCollectionView
            options: ->
              property = if @model.isNew()
                @_properties.first()
              else
                @model.personal_property

              collection: property.property_units
        ]

      stickit:
        bindings:
          '.gc-property-value':
            observe: ['value', 'value2']
            onGet: ([value, value2]) ->
              _.chain([value, value2]).compact().join('-').value()
            onSet: (input) ->
              input.split(/\-+/)

    ui:
      removeButton: '.gc-remove'
      value: '.gc-property-value'

    events:
      'click @ui.removeButton': '_removeProperty'
      'keypress @ui.value': '_handleKeyPress'
      'paste @ui.value': '_handlePaste'

    initialize: ->
      @view._properties = App.request('data:personal_properties:visible')

    onShow: ->
      @listenTo(@view.views.properties_select_box, 'selected', @selectProperty)
      _.chain(@_selectValue).bind(@).delay(100)

    selectProperty: (model) ->
      unless @view.model.get('personal_property_id')
        value = @view.model.get('value')
        value2 = @view.model.get('value2')
      @view.model.set
        personal_property_id: model.id
        personal_property: model.attributes
        property_name: model.get('name')
        value: value or null
        value2: value2 or null
      @_selectValue()

    _removeProperty: (ev) ->
      ev.preventDefault()
      ev.stopImmediatePropagation()
      @view.model.destroy(wait: true)

    _selectValue: ->
      @ui.value.focus()
      @ui.value.selectText()

    _handlePaste: (ev) ->
      ev.preventDefault()
      data = ev.clipboardData ||
        ev.originalEvent.clipboardData ||
        window.clipboardData
      [value, value2] = data
        .getData('text')
        .replace(/[^\d\-]/ig, '')
        .split(/\s*\-\s*/)
      @view.model.set
        value: value
        value2: value2
      false

    _handleKeyPress: (ev) ->
      @_saveOnEnter(ev) or @_typeAllowedChars(ev)

    _saveOnEnter: (ev) ->
      if ev.which is 13
        ev.preventDefault()
        @view._saveProperty()
        false

    _typeAllowedChars: (ev) ->
      key = ev.keyCode || ev.which
      char = String.fromCharCode(key)
      currentValue = $(ev.currentTarget).text()

      if key in [8, 46]
        return true
      else if not @_inputValuesLengthIsValid(currentValue)
        return false
      else if char.match(/[\-]/) and not currentValue.match(/[\d]+/)
        return false
      else if char.match(/[\-]/) and currentValue.match(/[\-]+/)
        return false
      if not char.match(/[\d\-]/i)
        return false

    _inputValuesLengthIsValid: (text) ->
      _.all text.split(/\s*\-\s*/), (value) ->
        value.length <= 4
