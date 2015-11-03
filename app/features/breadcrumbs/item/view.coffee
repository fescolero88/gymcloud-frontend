define ->

  class BreadcrumbsItemView extends Marionette.ItemView

    template: -> ''

    tagName: 'span'

    events:
      'keydown': '_preventEnter'

    behaviors: ->
      stickit:
        bindings:
          ':el':
            observe: 'name'
            events: ['blur']

    modelEvents:
      'change:name': '_saveName'

    initialize: (options) ->
      @oldName = @model.get('name')
      @isEditable = options.isEditable

    _saveName: ->
      condition = !_.isUndefined(@oldName) &&
        @model.hasChanged('name') &&
        @model.get('name') != @oldName
      if condition
        @model.save()
          .then =>
            @oldName = @model.get('name')
          .fail (_xhr, _textStatus, _errorThrown) =>
            @model.set(name: @oldName)

    _preventEnter: (ev) ->
      if ev.which in [13, 27]
        ev.preventDefault()
        $(ev.currentTarget).blur()
