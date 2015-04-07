Marionette = require 'backbone.marionette'
Backbone = require 'backbone'
AvatarView = require 'views/general/search/avatar-view'

module.exports = class ResultsClientItemView extends Marionette.LayoutView

  className: 'row'

  template: Templates.general.search.group_item_for_client

  regions:
    avatarWrapper: 'region[data-name="avatar-wrapper"]'

  templateHelpers: ->
    id = @model.id
    entity_link: "/#/tr/clients/id/#{id}/exercises/"

  ui:
    avatarWrapper: '.gc-avatar-wrapper'

  onRender: ->
    avatarView = new AvatarView
      model: @model
    @getRegion('avatarWrapper').show avatarView
