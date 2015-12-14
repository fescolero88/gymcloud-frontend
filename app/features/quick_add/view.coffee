define [
  './template'
  './model'
], (
  template
  Model
) ->

  class View extends Marionette.ItemView

    template: template

    ui:
      'button': 'button'
      'inputWrapper': '.gc-exercises-assign-input-wrapper'

    events: ->
      'click @ui.button': =>
        @model.set('state', 'autocomplete')
        @$el.find('.selectize-input input').focus()
      'blur @ui.inputWrapper': =>
        @model.set('state', 'button')

    behaviors: ->

      stickit:
        bindings:
          'button':
            observe: 'state'
            visible: (value) ->
              value is 'button'
          '.gc-exercises-assign-input-wrapper':
            observe: 'state'
            visible: (value) ->
              value is 'autocomplete'

      auto_complete:
        onItemAdd: ((view) ->
          (value, $item) ->
            @clear()
            view.trigger('quick_add:chosen', value, $item)
        )(@)
        collection: ->
          #_.result(@options, 'collection')
          App.request('current_user').exercises
            .map (item) ->
              folder: false
              id: item.get('id')
              name: item.get('name')
              label: item.get('name')

    constructor: ->
      @model = new Model
      super

    initialize: ->
      @listenTo @, 'quick_add:chosen', =>
        @ui.inputWrapper.trigger('blur')
