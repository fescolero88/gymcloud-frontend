define [
  './view'
], (
  HeaderView
) ->

  class Module extends Marionette.Module

    initialize: ->

      @on 'start', ->
        @_initVentListeners()

    _initVentListeners: ->
      @app.vent.on('app:view:main:render', @_renderHeaderView)

    _renderHeaderView: (targetView) ->
      view = new HeaderView
      targetView.getRegion('header').show(view)
