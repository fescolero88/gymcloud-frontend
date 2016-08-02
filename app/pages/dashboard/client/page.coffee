define [
  'pages/base/page'
  'features/dashboard/completion_ring/view'
  'features/dashboard/trainer_info/view'
  './template'
], (
  BasePage
  CompletionRingView
  TrainerInfoView
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
        ]

    initModel: ->
      model = new Backbone.Model
      model.urlRoot = '/dashboards/client'
      model

    initViews: ->
      root: ->

    onDomRefresh: ->
      @_owlCarouselInit()

    _owlCarouselInit: ->
      @ui.calendar.owlCarousel
        navigation: true
        slideSpeed: 250
        paginationSpeed: 250
        singleItem: true