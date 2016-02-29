define [
  './template'
], (
  template
) ->
  class ProgramPresetItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'account-type-item'

    events:
      'click': 'changeSelected'

    behaviors:

      stickit:
        bindings:
          ':el':
            classes:
              active: 'is_selected'
          'h5': 'name'
          '.account-selected':
            classes:
              assigned: 'is_selected'


    changeSelected: ->
      is_selected = !@model.get('is_selected')
      @model.set(is_selected: is_selected)
