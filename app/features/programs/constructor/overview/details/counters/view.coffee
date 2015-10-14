define [
  './template'
], (
  template
) ->

  class CountersView extends Marionette.LayoutView

    className: 'gc-block-group clearfix gc-program-counter'

    template: template

    behaviors:

      stickit:
        bindings:
          '[data-bind="weeksCount"]': 'weeksCount'
          '[data-bind="workoutsCount"]': 'workoutsCount'

    initialize: (options) ->
      @weekCollection = options.weekCollection
      @workoutsCollection = options.workoutsCollection

      @model = new Backbone.Model
      @_update_week_count()
      @_update_workouts_count()

      @listenTo(@weekCollection, 'update', @_update_week_count)
      @listenTo(@workoutsCollection, 'update', @_update_workouts_count)

    _update_week_count: ->
      count = @weekCollection.length
      @model.set(weeksCount: count)

    _update_workouts_count: =>
      count = @weekCollection.reduce((memo, model) ->
        memo + model.get('program_workouts').length
      , @workoutsCollection.length)
      @model.set(workoutsCount: count)
