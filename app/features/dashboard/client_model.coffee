define [
  'models/concerns/nested_models'
  './scheduled_workout_slider/collection'
], (
  NestedModelsConcern
  WorkoutEventCollection
) ->

  class ClientDashboardModel extends Backbone.Model

    type: 'ClientDashboardModel'

    urlRoot: '/dashboards/client'

    constructor: ->
      @_nestedModelsInit
        scheduled_workouts: WorkoutEventCollection
        completed_workouts: WorkoutEventCollection
      super

    parse: (data) ->
      @_nestedModelsParseAll(scheduled_workouts: [{}, {}, {}, {}])
      data

  _.extend(ClientDashboardModel::, NestedModelsConcern)

  ClientDashboardModel