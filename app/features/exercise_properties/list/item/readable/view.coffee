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
            observe: ['personal_property', 'value']
            onGet: ([property, value]) ->
              if value
                "#{value} #{property.global_property.unit}"
              else
                "#{property.name}"

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
