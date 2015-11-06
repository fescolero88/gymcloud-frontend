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
      console.log 'inited'
      @collection = new VideosListCollection
      @collection.fetch()

    childEvents:
      assign: 'sendEvent'
      playVideo: 'replaceIframe'

    sendEvent: (childView) ->
      debugger
      @trigger('assignVideo', childView.model)

    replaceIframe: (childView) ->
      @activeVideo?.trigger('destroyIframe')
      @activeVideo = childView