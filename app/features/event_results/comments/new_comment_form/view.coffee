define [
  './template'
], (
  template
) ->

  class NewCommentFormView extends Marionette.ItemView

    template: template

    className: 'gc-comment-enter-message'

    behaviors:

      stickit:
        bindings:
          'textarea' : 'comment'
