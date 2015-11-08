define [
  './item/view'
  './empty/start_search'
  './empty/no_results'
  './empty/in_progress'
  './empty/library'
], (
  AssignVideoItemView
  StartSearchView
  NoResultsView
  InProgressView
  LibraryView
) ->
  class AssignVideosView extends Marionette.CollectionView

    className: 'gc-assign-videos'

    childView: AssignVideoItemView

    getEmptyView: ->
      switch @viewState.get('state')
        when 'search_not_started' then StartSearchView
        when 'no_results' then NoResultsView
        when 'in_progress' then InProgressView
        when 'library' then LibraryView

    childEvents:
      assign: 'sendEvent'
      playVideo: 'replaceIframe'

    initialize: =>
      @viewState = new Backbone.Model(
        state: 'library'
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