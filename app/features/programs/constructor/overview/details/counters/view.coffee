define [
  'backbone.marionette'
  './template'
], (
  Marionette
  template
) ->

  class CountersView extends Marionette.LayoutView

    className: 'gc-block-group clearfix gc-program-counter'

    template: template

    bindings:
      '[data-bind="weeksCount"]': 'weeksCount'
      '[data-bind="workoutsCount"]': 'workoutsCount'

    initialize: (options) ->
      @weekCollection = options.weekCollection
      @workoutsCollection = options.workoutsCollection
      @weekWorkoutsCollection = options.weekWorkoutsCollection

      @model = new Backbone.Model
      @_update_week_count()
      @_update_workouts_count()

      @listenTo(@weekCollection, 'update', @_update_week_count)
      @listenTo(@workoutsCollection, 'update', @_update_workouts_count)
      @listenTo(@weekWorkoutCollection, 'update', @_update_workouts_count)

    onRender: ->
      @stickit()

    onDestroy: ->
      @unstickit()

    _update_week_count: ->
      count = @weekCollection.length
      @model.set(weeksCount: count)

    _update_workouts_count: ->
      count = @workoutsCollection.length + @weekWorkoutsCollection.length
      @model.set(workoutsCount: count)
