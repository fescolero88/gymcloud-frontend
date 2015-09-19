define [
  './view'
], (
  SpinnerView
) ->

  class Module extends Marionette.Module

    initialize: ->
      @_initRegion()
      @_initSpinner()
      @_initHandlers()
      @

    _initRegion: ->
      @app.addRegions
        spinnerRegion: 'region[data-name="spinner"]'

    _initSpinner: ->
      @spinner = new SpinnerView

    _initHandlers: ->
      @listenTo @app.vent.on 'spinner:start', =>
        @spinner.trigger('start')
      @listenTo @app.vent.on 'spinner:stop', =>
        @spinner.trigger('stop')
      @listenTo @app, 'start', =>
        @_showView()
      @listenTo @app, 'started', =>
        @app.vent.trigger('spinner:stop')
      @listenTo @app, 'started', =>
        @_initAjax()

    _initAjax: =>
      loadingCount = 0
      $(document).ajaxStart =>
        if ++loadingCount is 1
          @app.vent.trigger('spinner:start')
      $(document).ajaxComplete =>
        if @app._isStarted && loadingCount > 0 && --loadingCount is 0
          @app.vent.trigger('spinner:stop')

    _showView: ->
      region = @app.getRegion('spinnerRegion')
      region.show(@spinner)
