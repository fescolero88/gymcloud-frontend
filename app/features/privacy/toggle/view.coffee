define [
  './template'
], (
  template
) ->

  class View extends Marionette.ItemView

    template: template

    className: 'btn-group gc-btn-group gc-privacy-toggle'

    attributes: 'data-toggle': 'buttons'

    modelAttribute: 'is_public'

    behaviors:

      stickit:
        bindings: ->
          'label.role-on':
            classes:
              active: @modelAttribute
          'label.role-off':
            classes:
              active:
                observe: @modelAttribute
                onGet: (value) ->
                  not value

    events: ->
      'click label': (ev) ->
        ev.preventDefault()
        value = $(ev.currentTarget).find('input').val() is 'true'
        @model.set(@modelAttribute, value)

    modelEvents: ->
      "change:#{@modelAttribute}": '_saveAttr'

    onBeforeRender: ->
      @oldValue = @model.get(@modelAttribute)

    _saveAttr: ->
      newValue = @model.get(@modelAttribute)
      if @model.hasChanged(@modelAttribute) && newValue isnt @oldValue
        @model.save(@model.pick(@modelAttribute), patch: true)
          .then => @oldValue = newValue
          .fail => @model.set(@modelAttribute, @oldValue)
