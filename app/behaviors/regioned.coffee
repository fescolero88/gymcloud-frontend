define ->

  class RegionedBehavior extends Marionette.Behavior

    key: 'regioned'

    defaults:
      views: []

    initialize: ->
      @_bindAll()
      @view.views = {}
      super
      @_initRegions()
      @

    onBeforeRender: ->
      @_initBehaviorViews()

    onRender: ->
      @_ensureDataIsSynced()
        .done =>
          @_renderBehaviorViews()

    _ensureDataIsSynced: ->
      defer = new $.Deferred
      dfds = {}
      _.each ['model', 'collection'], (namespace) =>
        dfds[namespace] = new $.Deferred
        if @view[namespace] and not @view[namespace]._isSynced
          @listenToOnce(@view[namespace], 'sync', ->
            dfds[namespace].resolve())
        else
          dfds[namespace].resolve()
        _.delay(dfds[namespace].resolve, 500)
      $.when(_.values(dfds)...).then(defer.resolve)
      defer.promise()

    _initRegions: ->
      @_doForEach (view) =>
        selector = @_getRegionSelector(view.region)
        @view.addRegion(view.region, selector)

    _getRegionSelector: (regionName) ->
      "region[data-name='#{regionName}']"

    _initBehaviorViews: ->
      @_doForEach (view) =>
        view.options ?= -> @options
        view.enabled ?= -> true
        options = _.bind(view.options, @view)()
        @view.views[view.region] = new view.klass(options)

    _renderBehaviorViews: ->
      @_doForEach (view) =>
        enabled = _.bind(view.enabled, @view)()
        v = @view.views[view.region]
        if enabled
          @view
            .getRegion(view.region)
            .show(v)

    _doForEach: (fn) ->
      _.each(@options.views, fn)

    _bindAll: ->
      fns = [
        '_initRegions'
        '_initBehaviorViews'
        '_renderBehaviorViews'
        '_doForEach'
      ]
      _.bindAll(@, fns...)
