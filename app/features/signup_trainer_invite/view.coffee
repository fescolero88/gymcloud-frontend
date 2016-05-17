define [
  './template'
], (
  template
) ->

  class TrainerInviteView extends Marionette.ItemView

    template: template

    onShow: ->
      $('body').attr('class', 'auth')

    onDestroy: ->
      $('body').removeClass('auth')
