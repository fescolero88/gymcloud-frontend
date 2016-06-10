define [
  './template'
], (
  template
) ->

  class NewExerciseResultItemView extends Marionette.ItemView

    className: 'input-wrapper'

    template: template

    behaviors: ->

      stickit:

        bindings:
          'input':
            observe: 'value_converted'
            events: ['blur', 'change']
          'label':
            observe: ['personal_property', 'property_unit_name']
            onGet: ([property, units]) ->
              "#{property.name} (#{units})"

