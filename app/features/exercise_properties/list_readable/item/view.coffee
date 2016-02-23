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
