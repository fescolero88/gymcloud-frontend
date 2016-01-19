define [
  'dragula'
], (
  Dragula
) ->

  class Module extends Marionette.Module

    initialize: ->
      @_initInstance()
      @_initHandlers()

    _initInstance: ->
      options =
        isContainer: (el) ->
          el.classList.contains('draggable-container')
        moves: (el, source, handle, sibling) ->
          handle.classList.contains('draggable-handle')

      @smaug = Dragula [], options

      @smaug.on 'drop', (el, target, source, sibling) ->
        App.vent.trigger('drag_n_drop:item:dropped', arguments...)

    _initHandlers: ->
      @app.reqres.setHandlers

        'drag_n_drop:instance': =>
          @smaug