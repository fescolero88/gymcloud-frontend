define [
  './base_view'
  './templates/client'
], (
  BaseView
  template
) ->

  class ClientView extends BaseView

    template: template

    templateHelpers: ->
      id = @model.get('id')
      entity_link: "#users/#{id}"
      first_name: @model.get('first_name') || @model.get('user_profile').first_name
      last_name: @model.get('last_name') || @model.get('user_profile').last_name
