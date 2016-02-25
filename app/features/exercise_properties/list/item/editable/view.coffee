define [
  './template'
  'features/properties/select_box/view'
], (
  template
  PropertiesSelectBox
) ->

  class ExercisePropertiesListItemView extends Marionette.LayoutView

    template: template

    tagName: 'li'

    className: 'gc-property-item'

    behaviors:

      regioned:
        views: [
            region: 'properties_select_box'
            klass: PropertiesSelectBox
            options: ->
              default_property: @model.get('personal_property')
        ]

      stickit:
        bindings:
          '.gc-property-value':
            observe: ['value', 'value2']
            onGet: ([value, value2]) ->
              _.chain([value, value2]).compact().join('-').value()
            onSet: (input) ->
              input.split(/\-+/)

    ui: ->
      value: '.gc-property-value'
      removePropertyButton: '.gc-remove'
      editPropertyControl: '.gc-property'
      savePropertyButton: '.gc-save'

    events: ->
      'click @ui.removePropertyButton': '_removeProperty'
      'focusout': _.debounce(@saveOnBlur, 200)
      'keypress @ui.value': '_handleKeyPress'
      'paste @ui.value': '_handlePaste'
      'click @ui.savePropertyButton': '_saveProperty'

    onShow: ->
      @listenTo(@views.properties_select_box, 'selected', @selectProperty)
      _.chain(@_selectValue).bind(@).delay(100)

    _selectValue: ->
      @ui.value.focus()
      @ui.value.selectText()

    _removeProperty: (ev) ->
      ev.preventDefault()
      ev.stopImmediatePropagation()
      @model.destroy(wait: true)

    selectProperty: (model) ->
      @model.set
        personal_property_id: model.id
        personal_property: model.attributes
      @ui.value.focus()

    _handlePaste: (ev) ->
      ev.preventDefault()
      data = ev.clipboardData ||
        ev.originalEvent.clipboardData ||
        window.clipboardData
      [value, value2] = data
        .getData('text')
        .replace(/[^\d\-]/ig, '')
        .split(/\s*\-\s*/)
      @model.set
        value: value
        value2: value2
      false

    _handleKeyPress: (ev) ->
      @_saveOnEnter(ev) or @_typeAllowedChars(ev)

    _saveOnEnter: (ev) ->
      if ev.which is 13
        ev.preventDefault()
        @_saveProperty()
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

    _saveProperty: ->
      @model.save({}, {wait: true}).then ->
        App.request('messenger:explain', 'exercise.updated')
      .fail ->
        App.request('messenger:explain', 'error.unknown')
      .always =>
        @trigger('switchTo:readable')

    saveOnBlur: (ev) ->
      activeEl = $(':focus')
      if @ui.editPropertyControl.find(activeEl).length is 0
        @_saveProperty()
