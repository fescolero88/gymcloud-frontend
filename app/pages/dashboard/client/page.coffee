define [
  'pages/base/page'
  'features/dashboard/client_model'
  'features/dashboard/trainer_info/view'
  'features/dashboard/completion_ring/view'
  'features/dashboard/scheduled_workout_slider/view'
  'features/dashboard/workout_events/view'
  './template'
], (
  BasePage
  ClientDashboardModel
  TrainerInfoView
  CompletionRingView
  ScheduledWorkoutSliderView
  WorkoutEventsView
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
              event: @model.get('data.model')
              description: 'Workouts completed this week'
              className: 'gc-workout-indicator client'
          ,
            region: 'scheduled_workout_slider'
            klass: ScheduledWorkoutSliderView
            options: ->
              collection: @model.get('data.model').scheduled_workouts
          ,
            region: 'workout_events'
            klass: WorkoutEventsView
            options: ->
              scheduled_workouts: @model.get('data.model').scheduled_workouts
              past_workouts: @model.get('data.model').past_workouts
        ]

    initModel: ->
      new ClientDashboardModel

    initViews: ->
      root: ->
