define [
  './template'
  '../pro_invite/model'
], (
  template
  Model
) ->

  class FindProView extends Marionette.ItemView

    template: template

    onShow: ->
      $('body').attr('class', 'auth')

    onDestroy: ->
      $('body').removeClass('auth')

    initialize: ->
      model = new Model
      model.request()
