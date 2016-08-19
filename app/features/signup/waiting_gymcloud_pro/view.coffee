define [
  './template'
], (
  template
) ->

  class WaitingGymcloudProView extends Marionette.ItemView

    template: template

    onShow: ->
      $('body').attr('class', 'auth')

    onDestroy: ->
      $('body').removeClass('auth')
