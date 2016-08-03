define [
  './model'
  './list/view'
  './template'
], (
  DataModel
  WorkoutEventsTableView
  template
) ->

  class WorkoutEventsView extends Marionette.LayoutView

    template: template

    behaviors: ->

      regioned:
        views: [
            region: 'scheduled_workouts'
            klass: WorkoutEventsTableView
            options: =>
              collection: @options.scheduled_workouts
              withStatus: false
          ,
            region: 'completed_workouts'
            klass: WorkoutEventsTableView
            options: =>
              collection: @options.completed_workouts
              withStatus: true
        ]

    initialize: ->
      @model = new DataModel
