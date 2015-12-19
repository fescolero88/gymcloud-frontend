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

    events:
      'click @ui.addToLibraryButton': '_showAddToLibrary'

    behaviors: ->
      _.extend super,
        stickit:
          bindings:
            '[data-name="is_in_my_library"]':
              attributes: [
                  observe: 'is_in_my_library'
                  name: 'class'
                  onGet: (val) ->
                    type = @options.entity_context
                    if type != 'exercises'
                      type = "#{_.singularize(type)}_templates"
                    if val
                      'gc-check-icon'
                    else
                      "gc-exercises-item-icon gc-exercises-item-icon-#{type}"
              ]
            '.gc-clients-list-client-link:first': 'name'
            '.gc-avatar-wrapper .gc-clients-list-client-link':
              observe: 'author_full_name'
              attributes: [
                observe: 'author_id'
                name: 'href'
                onGet: (val) ->
                  "#/users/#{val}"
              ]
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
            '.actions':
              classes:
                'gc-not-in-library':
                  observe: 'is_in_my_library'
                  onGet: (val) ->
                    not val

    _showAddToLibrary: ->
      App.request 'base:addToLibraryModal',
        model: @model
        type: @options.entity_context
