define [
  './template'
  './list/view'
], (
  template
  CommentCollectionView
) ->

  class CommentsLayoutView extends Marionette.LayoutView

    className: 'gc-comment-box clearfix'

    template: template

    behaviors: ->

      regioned:
        views: [
            region: 'comments_list'
            klass: CommentCollectionView
            options: ->
              collection: @options.collection
        ]
