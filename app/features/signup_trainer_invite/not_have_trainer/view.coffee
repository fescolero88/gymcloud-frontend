define [
  './template'
], (
  template
) ->

  class NotHaveTrainerView extends Marionette.ItemView

    template: template

    onShow: ->
      $('body').attr('class', 'auth')

    onDestroy: ->
      $('body').removeClass('auth')
