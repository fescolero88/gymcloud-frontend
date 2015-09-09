WorkoutGlobalAssignClientsListView = require 'views/trainer/workouts/workout_global_assign_clients_list'
WorkoutGlobalAssignGroupsListView = require 'views/trainer/workouts/workout_global_assign_groups_list'
Clients = require 'collections/clients'
ClientGroups = require 'collections/client_groups'
WorkoutClientAssignees = require 'collections/workouts_client_assignees'

module.exports = class WorkoutGlobalAssignView extends Marionette.LayoutView

  template: require('templates/trainer/workouts/workout_global_assign')

  regions:
    clients: 'region[data-name="workout-clients"]'
    groups: 'region[data-name="workout-groups"]'

  initialize: ->
    @clientsCollection = new Clients
    @groupsCollection = new ClientGroups
    @clientAssigneesCollection = new WorkoutClientAssignees

    @listenTo @clientAssigneesCollection, 'sync', @loadAssignmentScreen

    # retrieve assignees first before loading assignment ui
    @clientAssigneesCollection.id = @model.get 'id'
    @clientAssigneesCollection.fetch()

  loadAssignmentScreen: ->
    assignees = @clientAssigneesCollection.at(0)

    workoutGlobalAssignClientsListView = new WorkoutGlobalAssignClientsListView
      collection: @clientsCollection
      clientAssignees: assignees.get 'clients'
      workoutId: @model.get 'id'

    workoutGlobalAssignGroupsListView = new WorkoutGlobalAssignGroupsListView
      collection: @groupsCollection
      groupAssignees: assignees.get 'client_groups'
      workoutId: @model.get 'id'

    @getRegion('clients').show workoutGlobalAssignClientsListView
    @getRegion('groups').show workoutGlobalAssignGroupsListView

    @clientsCollection.fetch()
    @groupsCollection.fetch()
