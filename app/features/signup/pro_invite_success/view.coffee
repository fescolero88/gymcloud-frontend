define [
  './template'
  '../pro_invite/model'
], (
  template
  Model
) ->

  class ProInviteSuccessView extends Marionette.ItemView

    template: template

    onShow: ->
      $('body').attr('class', 'auth')

    onDestroy: ->
      $('body').removeClass('auth')
