define [
  'pages/base/page'
  './template'
  'features/dashboard/pro_model'
  'features/dashboard/info_tables/view'
  'features/dashboard/client_performance/view'
], (
  BasePage
  template
  ProDashboardModel
  InfoTablesView
  ClientPerformanceCollectionView
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
                #   region: 'scheduled_workouts'
                #   klass: WorkoutEventsTableView
                #   options: =>
                #     collection: @options.scheduled_workouts
                #     withStatus: false
                # ,
                # | Workouts this week
                # | Client Performance
                # | Missed workouts
                  region: 'client_performance'
                  name: 'Client Performance'
                  klass: ClientPerformanceCollectionView
                  options: =>
                    collection: @model.get('data.model').client_performance
              ]
        ]

    initModel: ->
      new ProDashboardModel({}, user_id: App.request('current_user_id'))

    initViews: ->
      root: ->
