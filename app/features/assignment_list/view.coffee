define [
  './clients/view'
  './groups/view'
  './template'
], (
  AssignClientsListView
  AssignGroupsListView
  template
) ->

  class AssignView extends Marionette.LayoutView

    template: template

    regions:
      clients: 'region[data-name="clients"]'
      groups: 'region[data-name="groups"]'

    initialize: (options) ->
      @assignClientsView = new AssignClientsListView
        collection: App.request('current_user').clients
        clientAssignees: @model.assignees
        entity: @model
        entityType: options.entityType
      @assignGroupsView = new AssignGroupsListView
        collection: @model.groupAssignments
        entity: @model
        entityType: options.entityType

    onShow: ->
      @getRegion('clients').show(@assignClientsView)
      @getRegion('groups').show(@assignGroupsView)