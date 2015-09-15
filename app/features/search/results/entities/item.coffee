define [
  './base_view'
  './templates/item'
], (
  BaseView
  template
) ->

  class ItemView extends BaseView

    template: template

    ui:
      addToLibraryButton: '.gc-add-to-library-button'
      profileLink: '.gc-profile-link'

    events:
      'click @ui.addToLibraryButton': '_showAddToLibrary'
      'click @ui.profileLink': '_preventNavigate'

    templateHelpers: ->
      entity_context = @options.entity_context

      type: entity_context
      profile_link: '#users/me'
      entity_link: "#tr/global/#{entity_context}/id/#{@model.id}"

    behaviors:

      stickit:
        bindings:
          '.gc-clients-list-client-link:first': 'name'
          '.gc-exercises-item-play-icon':
            attributes: [
              observe: 'video_url'
              name: 'style'
              onGet: (val) ->
                if val
                  'display: inline-block;'
                else
                  'display: none;'
            ]

    _showAddToLibrary: ->
      App.request 'base:addToLibraryModal',
        model: @model
        type: @options.entity_context

    _preventNavigate: (ev) ->
      ev.preventDefault()
