define [
  './template'
  './model'
], (
  template
  Model
) ->

  class TrainerInviteView extends Marionette.ItemView

    template: template

    behaviors: ->

      stickit:
        bindings:
          'input[name="name"]':'name'
          'input[name="email"]':'email'

    events:
      'submit form': '_onFormSubmit'

    initialize: ->
      @model = new Model

    onShow: ->
      $('body').attr('class', 'auth')

    onDestroy: ->
      $('body').removeClass('auth')

    _onFormSubmit: ->
      @model.save()
        .then(_.bind(@_invite, @))

    _invite: ->
      email = @model.get('email')
      @model.invite(email)
        .then(@_onInvite)

    _onInvite: ->
      App.vent.trigger('redirect:to', ['pro_invite_success'], replace: false)
