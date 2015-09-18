define [
  './clients/view'
  './template'
], (
  AssignClientsListView
  template
) ->

  class AssignView extends Marionette.LayoutView

    template: template

    regions:
      clients: 'region[data-name="clients"]'
      groups: 'region[data-name="groups"]'

    initialize: ->
      @assignClientsView = new AssignClientsListView
        collection: App.request('current_user').clients
        clientAssignees: @model.assignees
        entity: @model

    onShow: ->
      @getRegion('clients').show(@assignClientsView)