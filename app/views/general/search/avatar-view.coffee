Marionette = require 'backbone.marionette'

module.exports = class AvatarView extends Marionette.ItemView

  tagName: "a"

  template: Templates.general.search.avatar

  className: "gc-clients-list-avatar-wrapper"

  initialize: ->
    @backgroundColor = ""
    @avatar_url = ""
    
  attributes: ->
    
    # validation - model may come in different formats
    if @model.has('author')
      @backgroundColor = @model.get('author').avatar_background_color
      @avatar_url = @model.get('author').avatar_url || ""
    else
      @backgroundColor = @model.get('avatar_background_color')
      @avatar_url = @model.get('avatar_url') || ""

    "style": "background-color: #{@backgroundColor}"
    "href": "#"

  onRender: ->
    if @avatar_url
      this.$el.classList.add 'gc-clients-list-avatar-exist'
