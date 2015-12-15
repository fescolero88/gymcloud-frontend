define [
  './template'
], (
  template
) ->

  class PropertiesSelectBoxItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    behaviors:
      stickit:
        bindings:
          'a': 'name'

    triggers:
      'click a':
        event: 'selected'
        stopPropagation: false