Marionette = require 'backbone.marionette'
WorkoutGlobalAssignClientsListView = require 'views/trainer/workouts/workout_global_assign_clients_list'
ClientsCollection = require 'models/trainer/client-collection'

module.exports = class WorkoutGlobalAssignView extends Marionette.LayoutView

  template: Templates.trainer.workouts.workout_global_assign

  regions:
    clients: 'region[data-name="workout-clients"]'
    groups: 'region[data-name="workout-groups"]'

  initialize: ->
    @clientsCollection = new ClientsCollection()

  onShow: ->
    workoutGlobalAssignClientsListView = new WorkoutGlobalAssignClientsListView
      collection: @clientsCollection
    @getRegion('clients').show workoutGlobalAssignClientsListView

    @clientsCollection.fetch()
