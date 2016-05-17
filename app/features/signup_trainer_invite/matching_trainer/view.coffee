define [
  './template'
], (
  template
) ->

  class MatchingTrainerView extends Marionette.ItemView

    template: template

    onShow: ->
      $('body').attr('class', 'auth')

    onDestroy: ->
      $('body').removeClass('auth')
