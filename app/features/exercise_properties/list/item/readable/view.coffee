define [
  './template'
], (
  template
) ->

  class ExercisePropertiesListItemReadableView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'gc-property-item'

    behaviors:

      stickit:
        bindings:
          '.gc-property-value-name-label':
            observe: [
              'property_unit_name'
              'value_converted'
              'value2_converted'
            ]
            onGet: ([unit_name, value, value2]) ->
              if value
                "#{_.compact([value, value2]).join(' - ')} #{unit_name}"
              else
                @model.personal_property.get('name')

    ui: ->
      removePropertyButton: '.gc-remove'
      toggleEditMode: '.gc-toggle-edit-mode'

    events: ->
      'click @ui.removePropertyButton': 'removeProperty'
      'click @ui.toggleEditMode': 'toggleEditMode'

    toggleEditMode: (ev) ->
      ev.preventDefault()
      @trigger('switchTo:editable')

    removeProperty: (ev) ->
      ev.preventDefault()
      ev.stopImmediatePropagation()
      @model.destroy(wait: true)
