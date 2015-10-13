define [
  './view'
], (
  SidebarView
) ->

  class Module extends Marionette.Module

    initialize: ->

      @on 'start', ->
        @_initVentListeners()

    _initVentListeners: ->
      @app.vent.on('app:view:main:render', @_renderSidebarView)

    _renderSidebarView: (targetView) ->
      view = new SidebarView
      targetView.getRegion('menu')?.show(view)
