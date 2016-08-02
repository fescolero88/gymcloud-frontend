define [
  'pages/base/page'
  'features/dashboard/client_model'
  'features/dashboard/trainer_info/view'
  'features/dashboard/completion_ring/view'
  'features/dashboard/scheduled_workout_slider/view'
  './template'
], (
  BasePage
  ClientDashboardModel
  TrainerInfoView
  CompletionRingView
  ScheduledWorkoutSliderView
  template
) ->

  class Page extends BasePage

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    ui: calendar: '#workout-calendar'

    behaviors: ->

      regioned:
        views: [
            region: 'trainer_info'
            klass: TrainerInfoView
          ,
            region: 'completion_ring'
            klass: CompletionRingView
            options: ->
              model = @model.get('data.model')

              completed: model.get('events_completed_this_week_count')
              total: model.get('events_scheduled_this_week_count')
              description: 'Workouts completed this week'
              className: 'gc-workout-indicator client'
          ,
            region: 'scheduled_workout_slider'
            klass: ScheduledWorkoutSliderView
            options: ->
              collection: @model.get('data.model').scheduled_workouts
        ]

    initModel: ->
      new ClientDashboardModel

    initViews: ->
      root: ->
