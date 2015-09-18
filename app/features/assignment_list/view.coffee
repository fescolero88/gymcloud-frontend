define [
  './clients/view'
  './template'
], (
  AssignClientsListView
  template
) ->

  class WorkoutGlobalAssignView extends Marionette.LayoutView

    template: template

    regions:
      clients: 'region[data-name="workout-clients"]'
      groups: 'region[data-name="workout-groups"]'

    initialize: ->
      @clientsCollection = App.request('current_user').clients

    onShow: ->
      @loadAssignmentScreen()

    loadAssignmentScreen: ->
      assignClientsView = new AssignClientsListView
        collection: @clientsCollection
        clientAssignees: @model.assignees
        workout: @model

      @getRegion('clients').show(assignClientsView)