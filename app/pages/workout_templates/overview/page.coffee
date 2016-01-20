define [
  'pages/base/page'
  './template'
  'models/workout_template'
  'features/video/assignment/view'
  'features/assignment_list/view'
  './overview/view'
], (
  BasePage
  template
  WorkoutTemplate
  VideoAssignmentView
  AssignView
  OverviewView
) ->

  class Page extends BasePage

    behaviors:

      navigate_back: true

      breadcrumbs:
        model: ->
          @view.model.get('data.model')

      navigation_content_tabs:
        data: [
            id: 'overview'
            title: 'Overview'
            active: true
          ,
            id: 'video'
            title: 'Video'
          ,
            id: 'assign'
            title: 'Assign'
        ]

      privacy_widget:
        model: -> @view.model.get('data.model')

      add_to_library:
        model: -> @view.model.get('data.model')

      redirect_back_on_destroy:
        model: -> @view.model.get('data.model')

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    init: ->
      @model.set('state.subpage', @options.state)

    initModel: ->
      new WorkoutTemplate
        id: @options.id

    initViews: ->
      overview: ->
        view = new OverviewView
          model: @model.get('data.model')
        @listenTo view, 'childview:video:assign', =>
          @model.set('state.subpage', 'video')
        view
      video: ->
        view = new VideoAssignmentView
          model: @model.get('data.model')
        @listenTo view, 'video:assigned', =>
          @model.set('state.subpage', 'overview')
        view
      assign: ->
        new AssignView
          model: @model.get('data.model')

    onShow: ->
      @listenTo(@model.get('data.model'), 'change:video_url', @_videoAssigned)

    _videoAssigned: ->
      @model.set('state.subpage', 'overview')
