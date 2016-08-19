define [
  './template'
  './model'
], (
  template
  Model
) ->

  class View extends Marionette.ItemView

    template: template

    className: 'client-reg-select'

    behaviors: ->

      stickit:
        bindings:
          'input[type="radio"]': 'reg_type'
          'button':
            attributes: [
                name: 'disabled',
                observe: 'reg_type',
                onGet: (value) -> !value
            ]
            classes:
              disabled:
                observe: 'reg_type'
                onGet: (value) -> !value

    events:
      'submit form': '_onTypeSelected'

    initialize: ->
      @model = new Model

    onShow: ->
      $('body').attr('class', 'auth')

    onDestroy: ->
      $('body').removeClass('auth')

    _onTypeSelected: ->
      path = [@model.get('reg_type')]
      App.vent.trigger('redirect:to', path, replace: false)
