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
          '.gc-property-value': 'value'

    ui: ->
      removePropertyButton: '.gc-remove'
      selectedPropertyValue: '.gc-property-value'
      editPropertyControl: '.gc-property'
      savePropertyButton: '.gc-save'

    events: ->
      'click @ui.removePropertyButton': '_removeProperty'
      'focusout': _.debounce(@saveOnBlur, 200)
      'keypress @ui.selectedPropertyValue': '_saveOnEnter'
      'click @ui.savePropertyButton': '_saveProperty'

    onShow: ->
      @listenTo(@views.properties_select_box, 'selected', @selectProperty)
      setTimeout =>
        @ui.selectedPropertyValue.focus()
      , 200

    _removeProperty: (ev) ->
      ev.preventDefault()
      ev.stopImmediatePropagation()
      @model.destroy(wait: true)

    selectProperty: (model) ->
      @model.set
        personal_property_id: model.id
        personal_property: model.attributes
      @ui.selectedPropertyValue.focus()

    _saveOnEnter: (e) ->
      if e.which is 13
        e.preventDefault()
        @_saveProperty()

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
