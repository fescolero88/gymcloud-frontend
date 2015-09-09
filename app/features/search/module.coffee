define [
  './request/collection'
  './request/model'
  './router'
  './controller'
  './bar/view'
], (
  RequestCollection
  RequestModel
  Router
  Controller
  SearchBarView
) ->

  class Module extends Marionette.Module

    initialize: ->

      @on 'start', ->
        @_initModels()
        @_initRouter()
        @_initVentListeners()

    _initModels: ->
      collection = new RequestCollection
      @app.reqres.setHandler('search:request:collection', -> collection)
      model = new RequestModel
      @app.reqres.setHandler('search:request:model', -> model)
      model.on 'change', (model) ->
        collection.fetch
          data: model.attributes

    _initRouter: ->
      controller = new Controller
      @searchRouter = new Router
        controller: controller

    _initVentListeners: ->
      @app.vent.on('search:global', @_navigateToResults)
      @app.vent.on('app:view:header:render', @_renderSearchBarView)

    _navigateToResults: (q, entityType = 'all', searchScope = 'all') ->
      Backbone.history.navigate "search/#{q}/#{entityType}/#{searchScope}",
        trigger: true

    _renderSearchBarView: (targetView) ->
      view = new SearchBarView
      targetView.getRegion('searchBar').show(view)
