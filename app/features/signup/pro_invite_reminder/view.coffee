define [
  './template'
  '../pro_invite/model'
], (
  template
  Model
) ->

  class ProInviteReminderView extends Marionette.ItemView

    template: template

    events:
      'click button': '_invite'

    initialize: ->
      @model = new Model

    onShow: ->
      $('body').attr('class', 'auth')

    onDestroy: ->
      $('body').removeClass('auth')

    _invite: ->
      @model.invite()
        .then(@_onInvite)

    _onInvite: ->
      App.vent.trigger('redirect:to', ['pro_invite_success'], replace: false)
