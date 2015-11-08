define [
  'features/video_assignment/list/item/view'
  'collections/videos_list'
], (
  AssignVideoItemView
  VideosListCollection
) ->
  class LibraryView extends Marionette.CollectionView

    childView: AssignVideoItemView

    initialize: ->
      @collection = new VideosListCollection
      @collection.fetch()

    childEvents:
      assign: 'sendEvent'
      playVideo: 'replaceIframe'

    childViewOptions: (model, index) =>
      isAssigned: model.get('embed_url')?.length &&
        @options.templateEntity.get('video_url') is model.get('embed_url')

    sendEvent: (childView) ->
      @model = childView.model
      @trigger('assign')

    replaceIframe: (childView) ->
      @activeVideo?.trigger('destroyIframe')
      @activeVideo = childView