define [
  './model'
], (
  PageModel
) ->

  class BasePage extends Marionette.LayoutView

    constructor: (@options) ->
      @_bindAll()
      @views = {}
      @model = new PageModel
      @_initData()
      super
      @_initEvents()
      @_syncData()
      @init()
      @_showPage()
      @

    init: ->

    initModel: ->
      # NOTE: building a view model

    initCollection: ->
      # NOTE: building a view collection

    initViews: ->
      # NOTE: building sub views
      {}

    regionViews: ->
      # NOTE: mapping of region and views
      {}

    _initData: ->
      @_initDataModel()
      @_initDataCollection()

    _initDataModel: ->
      model = @model.get('data.model')
      unless model instanceof Backbone.Model
        model = @initModel()
        if model instanceof Backbone.Model
          @model.set('data.model', model)

    _initDataCollection: ->
      collection = @model.get('data.collection')
      unless collection instanceof Backbone.Collection
        collection = @initCollection()
        if collection instanceof Backbone.Collection
          @model.set('data.collection', collection)

    _initEvents: ->
      @listenTo(@, 'before:show', @_initViews)
      @listenTo(@, 'views:show', @_showView)
      @listenTo(@model, 'change:state', (_model, state) =>
        @trigger('views:show', state)
      )

    _initViews: ->
      @views = _.result(@, 'initViews')

    _showView: (name, regionName) ->
      fn = _.chain(@)
        .result('views')
        .get(name)
        .value()
      if typeof fn is 'function'
        fn = _.bind(fn, @)
      else
        return
      view = fn()
      regionName ||= 'page_content'
      region = @getRegion(regionName)
      region.show(view)

    _syncData: ->
      @_syncModel()
      @_syncCollection()

    _syncModel: ->
      model = @model.get('data.model')
      if _.any(model)
        model.fetch()

    _syncCollection: ->
      # FIXME: TBD

    _showPage: ->
      App.request('views:show', @)
      @model.set('state', @options.state)
      @_showView(@model.get('state'))

    _bindAll: ->
      _.bindAll @, [
        'init'
        'initModel'
        'initCollection'
        'initViews'
        'regionViews'
        '_initData'
        '_initDataModel'
        '_initDataCollection'
        '_initEvents'
        '_initViews'
        '_showView'
        '_syncData'
        '_syncModel'
        '_syncCollection'
        '_showPage'
      ]...
