define [
  './item/view'
], (
  AssignVideoView
) ->
  class AssignVideosView extends Marionette.CollectionView

    tagName: 'div'

    className: 'row gc-assign-videos'

    childView: AssignVideoView