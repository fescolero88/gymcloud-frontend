define [
  './avatar/view'
], (
  AvatarView
) ->

  class BaseView extends Marionette.LayoutView

    tagName: 'li'

    className: 'row'

    regions:
      avatar: 'region[data-name="avatar-wrapper"]'

    initialize: ->
      super
      @on('render', @_renderAvatar)

    _renderAvatar: ->
      view = new AvatarView
        model: @model
      @getRegion('avatar').show(view)
