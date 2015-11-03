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
      @listenTo @app.vent, 'spinner:start', =>
        @spinner.trigger('start')
      @listenTo @app.vent, 'spinner:stop', =>
        @spinner.trigger('stop')
      @listenTo @app, 'start', =>
        @_showView()
        @spinner.trigger('start')
      @listenTo @app, 'started', =>
        setTimeout =>
          @spinner.trigger('stop')
        , 500
      @listenTo @app, 'started', =>
        @_initAjax()

    _initAjax: =>
      count = 0

      $(document).ajaxStart =>
        count += 1
        if count is 1
          @app.vent.trigger('spinner:start')

      $(document).ajaxComplete =>
        if @app._isStarted && count > 0 && count -= 1 is 0
          @app.vent.trigger('spinner:stop')

    _showView: ->
      region = @app.getRegion('spinnerRegion')
      region.show(@spinner)
