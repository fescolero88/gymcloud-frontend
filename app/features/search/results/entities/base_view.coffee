define [
  './avatar/view'
], (
  AvatarView
) ->

  class BaseView extends Marionette.LayoutView

    tagName: 'li'

    className: 'row'

    behaviors: ->

      regioned:
        views: [
            region: 'avatar'
            klass: AvatarView
        ]
