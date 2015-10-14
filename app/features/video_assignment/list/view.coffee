define [
  './item/view'
  './empty/start_search'
  './empty/no_results'
], (
  AssignVideoItemView
  StartSearchView
  NoResultsView
) ->
  class AssignVideosView extends Marionette.CollectionView

    className: 'gc-assign-videos'

    childView: AssignVideoItemView

    getEmptyView: ->
      switch @viewState.get('state')
        when 'search_not_started' then StartSearchView
        when 'no_results' then NoResultsView

    childEvents:
      assign: 'sendEvent'
      playVideo: 'replaceIframe'

    initialize: =>
      @viewState = new Backbone.Model(
        state: 'search_not_started'
      )
      @listenTo(@viewState, 'change:state', @onStateChange)

    childViewOptions: (model, index) =>
      isAssigned: model.get('embed_url')?.length &&
        @model.get('video_url') is model.get('embed_url')

    onStateChange: ->
      @render() if @collection.length is 0

    sendEvent: (childView) ->
      @trigger('assignVideo', childView.model)

    replaceIframe: (childView) ->
      @activeVideo?.trigger('destroyIframe')
      @activeVideo = childView