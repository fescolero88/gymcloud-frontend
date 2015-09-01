define [
  './base_view'
  './templates/client_group'
], (
  BaseView
  template
) ->

  class ClientGroupView extends BaseView

    template: template

    templateHelpers: ->
      id = @model.get('id')
      entity_link: "#/tr/groups/id/#{id}/members/"
