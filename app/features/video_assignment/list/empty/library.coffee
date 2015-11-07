define [
  'features/video_assignment/list/item/view'
  'collections/videos_list'
], (
  AssignVideoItemView
  VideosListCollection
) ->
  class LibraryView extends Marionette.CollectionView

    childView: AssignVideoItemView

    className: 'gc-assign-videos'

    initialize: ->
      @collection = new VideosListCollection
      @collection.fetch()

    childEvents:
      assign: 'sendEvent'
      playVideo: 'replaceIframe'

    sendEvent: (childView) ->
      @model = childView.model
      @trigger('assign')

    replaceIframe: (childView) ->
      @activeVideo?.trigger('destroyIframe')
      @activeVideo = childView