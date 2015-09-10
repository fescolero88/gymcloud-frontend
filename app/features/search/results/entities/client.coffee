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