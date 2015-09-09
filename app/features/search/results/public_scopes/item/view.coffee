define [
  './template'
], (
  template
) ->

  class View extends Marionette.ItemView

    tagName: 'label'

    className: 'btn btn-primary'

    template: template

    bindings:
      'input':
        attributes: [
          name: 'value'
          observe: 'value'
        ]

      'span': 'name'

    onRender: ->
      @stickit()
      @_markAsActive()

    onDestroy: ->
      @unstickit()

    _markAsActive: ->
      if @model.get('inScope')
        @el.classList.add 'active'
