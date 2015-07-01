Marionette = require 'backbone.marionette'
Backbone = require 'backbone'
AvatarView = require 'views/general/search/avatar-view'

module.exports = class ResultsClientGroupItemView extends Marionette.LayoutView

  className: 'row'

  template: require('templates/general/search/group_item_for_client_group')

  regions:
    avatarWrapper: 'region[data-name="avatar-wrapper"]'

  templateHelpers: ->
    id = @model.id
    entity_link: "#/tr/groups/id/#{id}/members/"

  onRender: ->
    avatarView = new AvatarView
      model: @model

    @getRegion('avatarWrapper').show avatarView
