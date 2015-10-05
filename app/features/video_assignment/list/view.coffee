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
      'assign': 'sendEvent'

    childViewOptions: (model, index) =>
      isAssigned: @model.get('video_url') is model.get('embed_url')

    sendEvent: (childView) ->
      @trigger('assignVideo', childView.model)