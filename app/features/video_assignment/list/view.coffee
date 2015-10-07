define [
  './item/view'
], (
  AssignVideoView
) ->
  class AssignVideosView extends Marionette.CollectionView

    tagName: 'div'

    className: 'row gc-assign-videos'

    childView: AssignVideoView

    childEvents:
      assign: 'sendEvent'
      playVideo: 'replaceIframe'

    childViewOptions: (model, index) =>
      isAssigned: model.get('embed_url').length &&
        @model.get('video_url') is model.get('embed_url')

    sendEvent: (childView) ->
      @trigger('assignVideo', childView.model)

    replaceIframe: (childView) ->
      @activeVideo?.trigger('destroyIframe')
      @activeVideo = childView