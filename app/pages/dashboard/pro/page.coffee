define [
  'pages/base/page'
  './template'
  'features/dashboard/pro_model'
  'features/dashboard/info_tables/view'
  'features/dashboard/client_performance/view'
  'features/dashboard/missed_workout_events/view'
], (
  BasePage
  template
  ProDashboardModel
  InfoTablesView
  ClientPerformanceCollectionView
  MissedWorkoutEventsView
) ->

  class Page extends BasePage

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    behaviors: ->

      regioned:
        views: [
            region: 'info_tables'
            klass: InfoTablesView
            options: ->
              tables: [
                # | Workouts this week
                  region: 'client_performance'
                  name: 'Client Performance'
                  klass: ClientPerformanceCollectionView
                  options: =>
                    collection: @model.get('data.model').client_performance
                ,
                  region: 'missed_workout_events'
                  name: 'Missed workouts'
                  klass: MissedWorkoutEventsView
                  options: =>
                    collection: @model.get('data.model').missed_events
              ]
        ]

    initModel: ->
      new ProDashboardModel({}, user_id: App.request('current_user_id'))

    initViews: ->
      root: ->
