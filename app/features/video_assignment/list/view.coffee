define [
  './item/view'
], (
  AssignVideoItemView
) ->
  class AssignVideosView extends Marionette.CollectionView

    tagName: 'div'

    className: 'gc-assign-videos'

    childView: AssignVideoItemView

    childEvents:
      assign: 'sendEvent'
      playVideo: 'replaceIframe'

    childViewOptions: (model, index) =>
      isAssigned: model.get('embed_url')?.length &&
        @model.get('video_url') is model.get('embed_url')

    sendEvent: (childView) ->
      @trigger('assignVideo', childView.model)

    replaceIframe: (childView) ->
      @activeVideo?.trigger('destroyIframe')
      @activeVideo = childView