Marionette = require 'backbone.marionette'
AvatarView = require 'views/general/search/avatar-view'
Backbone = require 'backbone'

module.exports = class ResultsEntityItemView extends Marionette.LayoutView

  className: 'row'

  tagName: 'li'

  regions:
    avatarWrapper: 'region[data-name="avatar-wrapper"]'

  template: require('templates/general/search/group_item_for_entity')

  ui:
    addToLibraryButton: '.gc-add-to-library-button'
    profileLink: '.gc-profile-link'

  events:
    'click @ui.addToLibraryButton': 'showAddToLibrary'
    'click @ui.profileLink': 'preventNavigate'

  onRender: ->
    avatarView = new AvatarView
      model: @model
    @getRegion('avatarWrapper').show avatarView

  templateHelpers: ->
    userId = App.request('data:profile').get 'id'

    #TODO: works only for clients of current trainer. need to work for trainer's item and other users
    entity_context = @options.entity_context

    type: entity_context
    profile_link: '#/tr/me'
    author_full_name: "#{@model.get('author').first_name} #{@model.get('author').last_name}"
    author_link: "#/tr/clients/id/#{@model.get('author').id}/#{entity_context}/"
    entity_link: "#tr/global/#{entity_context}/id/#{@model.id}"
    is_in_my_library: userId is @model.get('author').id

  showAddToLibrary: ->
    App.request 'base:addToLibraryModal', type: @options.entity_context, model: @model

  preventNavigate: (ev) -> # UAT - temporarily disable navigation to user profiles
    ev.preventDefault()
