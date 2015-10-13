define [
  'dragula'
], (
  Dragula
) ->
  class Module extends Marionette.Module

    initialize: ->
      @_initHandlers()
      @_initGlobalSortable()

    _initHandlers: ->
      @listenTo @app.vent.on 'sortables:add:container', (container) =>
        @drake.containers.push container

      @listenTo @app.vent.on 'sortables:remove:container', (cont) =>
        containers = @drake.containers
        _.map containers, (el, index) ->
          if el is cont
            containers.splice(index, 1)

      @listenTo @app.vent.on 'sortables:get', =>
        @drake

    _initGlobalSortable: ->
      options =
        copy: true
        revertOnSpill: true
        moves: (el, container, handle) ->
          handle.classList.contains('draggable-handle')
        accepts: (el, container) ->
          !container.classList.contains('gc-sidebar-sub')

      @drake = Dragula [], options

      @drake.on 'drop', (el, container) ->
        args =
          category: el.getAttribute('data-category')
          id: el.querySelector('[data-key]').getAttribute('data-key')
        container.removeChild el
        App.vent.trigger 'sortables:on:drop', args