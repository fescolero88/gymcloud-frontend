define [
  './template'
], (
  template
) ->

  class CommentItemView extends Marionette.ItemView

    className: 'gc-comment'

    template: template
