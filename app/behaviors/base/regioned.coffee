define ->

  class BaseRegionedBehavior extends Marionette.Behavior

    key: -> @regionName

    # NOTE: name of a region where to show the view
    regionName: undefined

    # NOTE: view constructor function
    behaviorViewClass: undefined

    # NOTE: view options to pass
    behaviorViewOptions: {}

    defaults: {}

    initialize: ->
      super
      @_initRegion()
      _.bindAll @, [
        '_initBehaviorView'
        '_renderBehaviorView'
      ]...
      @listenTo(@view, 'before:show', @_initBehaviorView)
      @listenTo(@view, 'show', @_renderBehaviorView)
      @

    _initRegion: ->
      @view.addRegion(@regionName, @_getRegionSelector())

    _getRegionSelector: ->
      "region[data-name='#{@regionName}']"

    _initBehaviorView: ->
      options = _.result(@, 'behaviorViewOptions')
      @behaviorView = new @behaviorViewClass(options)

    _renderBehaviorView: ->
      @view.getRegion(@regionName)
        .show(@behaviorView)
