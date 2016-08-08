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

      stickit:
        bindings:
          '[data-name="scheduled_workouts"]':
            observe: 'tab'
            visible: (value) ->
              value is 'scheduled_workouts'
          '[data-name="completed_workouts"]':
            observe: 'tab'
            visible: (value) ->
              value isnt 'scheduled_workouts'
          '[tab-name="scheduled_workouts"]':
            classes:
              active:
                observe: 'tab'
                onGet: (value) ->
                  value is 'scheduled_workouts'
          '[tab-name="completed_workouts"]':
            classes:
              active:
                observe: 'tab'
                onGet: (value) ->
                  value isnt 'scheduled_workouts'

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
              collection: @options.past_workouts
              withStatus: true
        ]

    events:
      'click .tab-link': '_onChangeTab'

    initialize: ->
      @model = new DataModel

    _onChangeTab: (ev) ->
      tabName = $(ev.currentTarget).attr('tab-name')
      @model.set(tab: tabName)
