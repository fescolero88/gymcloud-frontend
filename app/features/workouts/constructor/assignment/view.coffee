define [
  './clients/view'
  'views/trainer/workouts/workout_global_assign_groups_list'
  'collections/clients'
  'collections/client_groups'
  'collections/workouts_client_assignees'
  './template'
], (
  WorkoutGlobalAssignClientsListView
  WorkoutGlobalAssignGroupsListView
  Clients
  ClientGroups
  WorkoutClientAssignees
  template
) ->

  class WorkoutGlobalAssignView extends Marionette.LayoutView

    template: template

    regions:
      clients: 'region[data-name="workout-clients"]'
      groups: 'region[data-name="workout-groups"]'

    initialize: ->
      @clientsCollection = App.request('current_user').clients
      # @groupsCollection = new ClientGroups
      # @clientAssigneesCollection = new WorkoutClientAssignees
      # @listenTo @clientAssigneesCollection, 'sync', @loadAssignmentScreen

      # retrieve assignees first before loading assignment ui
      # @clientAssigneesCollection.id = @model.get 'id'
      # @clientAssigneesCollection.fetch()

    onShow: ->
      @loadAssignmentScreen()

    loadAssignmentScreen: ->
      # assignees = @clientAssigneesCollection.at(0)

      assignClientsView = new WorkoutGlobalAssignClientsListView
        collection: @clientsCollection
        clientAssignees: @model.assignees
        workout: @model

      # workoutGlobalAssignGroupsListView = new WorkoutGlobalAssignGroupsListView
      #   collection: @groupsCollection
      #   groupAssignees: assignees.get 'client_groups'
      #   workoutId: @model.get 'id'

      @getRegion('clients').show(assignClientsView)
      # @getRegion('groups').show workoutGlobalAssignGroupsListView

      # @clientsCollection.fetch()
      # @groupsCollection.fetch()
