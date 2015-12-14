define [
  './template'
], (
  template
) ->

  class MainLayoutView extends Marionette.LayoutView

    template: template

    className: 'container-fluid'

    regions:
      menu: '.gc-sidebar-wrapper'
      header: '.gc-topbar'
      content: '.gc-main'
      modals: '.gc-modals'

    initialize: ->
      @_initHandlers()

    _initHandlers: ->
      App.reqres.setHandler('app:layouts:main', => @)
      @listenTo @, 'show', =>
        App.vent.trigger('app:layouts:main:render', @)

    onShow: ->
      App.vent.trigger('body:change-class', 'main')
