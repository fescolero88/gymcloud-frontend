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
      @listenTo @app.vent, 'sortables:add:container', (container) =>
        @drake.containers.push container

      @listenTo @app.vent, 'sortables:remove:container', (container) =>
        containers = @drake.containers
        _.map containers, (el, index) ->
          if el is container
            containers.splice(index, 1)

      @listenTo @app.vent, 'sortables:get', =>
        @drake

    _initGlobalSortable: ->
      options =
        copy: true
        revertOnSpill: true
        moves: (el, container, handle) ->
          el.classList.contains('gc-sidebar-item')
        accepts: (el, container) ->
          !container.classList.contains('gc-sidebar-sub')

      @drake = Dragula [], options

      @drake.on 'drop', (el, container) ->
        args =
          position: $(el).index() + 1
          el: el
          container: container
          category: el.getAttribute('data-category')
          id: el.querySelector('[data-key]').getAttribute('data-key')
        App.vent.trigger 'sortables:on:drop', args
