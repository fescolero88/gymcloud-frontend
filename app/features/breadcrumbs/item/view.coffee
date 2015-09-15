define [
  './template'
], (
  template
) ->

  class BreadcrumbsItemView extends Marionette.ItemView

    template: template

    tagName: 'span'

    events:
      'keydown': '_preventEnter'

    behaviors: ->
      if @options.isEditable
        stickit:
          bindings:
            ':el':
              observe: 'name'
              events: ['blur']

    modelEvents:
      'change:name': '_saveName'

    initialize: (options) ->
      @isEditable = options.isEditable

    _saveName: ->
      @model.save() if @model.hasChanged('name')

    _preventEnter: (ev) ->
      if ev.which in [13, 27]
        ev.preventDefault()
        $(ev.currentTarget).blur()