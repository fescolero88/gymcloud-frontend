define [
  './item/view'
  './empty/start_search'
  './empty/no_results'
  './empty/in_progress'
], (
  AssignVideoItemView
  StartSearchView
  NoResultsView
  InProgressView
) ->
  class AssignVideosView extends Marionette.CollectionView

    className: 'gc-assign-videos'

    childView: AssignVideoItemView

    getEmptyView: ->
      switch @viewState.get('state')
        when 'search_not_started' then StartSearchView
        when 'no_results' then NoResultsView
        when 'in_progress' then InProgressView

    childEvents:
      assign: 'sendEvent'
      playVideo: 'replaceIframe'

    initialize: =>
      @viewState = new Backbone.Model(state: 'library')
      @collection.fetch(data: q: '')
        .then =>
          @viewState.set(state: 'no_results') unless @collection.length
          @collection.trigger('request')
      @listenTo(@viewState, 'change:state', @onStateChange)

    childViewOptions: (model, index) =>
      templateEntity: @model
      isAssigned: model.get('embed_url')?.length &&
        @model.get('video_url') is model.get('embed_url')

    onStateChange: ->
      @render() if @collection.length is 0

    sendEvent: (childView) ->
      @trigger('assignVideo', childView.model)

    replaceIframe: (childView) ->
      @activeVideo?.trigger('destroyIframe')
      @activeVideo = childView