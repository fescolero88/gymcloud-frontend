define [
  'pages/base/page'
  './template'
  'models/exercise'
  './overview/view'
  'features/video/assignment/view'
], (
  BasePage
  template
  Exercise
  OverviewView
  VideoAssignmentView
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
          ,
            id: 'video'
            title: 'Video'
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

    initModel: ->
      new Exercise
        id: @options.id

    initViews: ->
      overview: ->
        view = new OverviewView
          model: @model.get('data.model')
        @listenTo view, 'childview:video:assign', =>
          @model.set('state', 'video')
        view

      video: ->
        view = new VideoAssignmentView
          model: @model.get('data.model')
        @listenTo view, 'video:assigned', =>
          @model.set('state', 'overview')
        view
