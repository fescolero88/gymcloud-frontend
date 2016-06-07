define [
  './item/view.coffee'
], (
  CommentItemView
) ->

  class CommentCollectionView extends Marionette.CollectionView

    tagName: 'list'

    childView: CommentItemView
