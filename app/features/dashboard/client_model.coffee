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
        workout_events: WorkoutEventCollection

      @scheduled_workouts = new Backbone.VirtualCollection @workout_events,
        filter: (model) -> model.get('begins_at_int') > moment().valueOf()
        comparator: 'begins_at_int'

      @past_workouts = new Backbone.VirtualCollection @workout_events,
        filter: (model) -> model.get('ends_at_int') < moment().valueOf()
        comparator: 'ends_at_int'

      super

    fetch: ->
      promise = @workout_events.fetch
        data:
          range_from: moment().startOf('week').toString()
          range_to: moment().endOf('week').toString()
        processData: true
      promise.then =>
        @set
          completed_count: @workout_events.where(is_completed: true).length
          scheduled_count: @workout_events.length
      promise

  _.extend(ClientDashboardModel::, NestedModelsConcern)

  ClientDashboardModel