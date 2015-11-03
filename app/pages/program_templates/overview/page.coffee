define [
  'pages/base/page'
  './template'
  'models/program_template'
  'features/assignment_list/view'
], (
  BasePage
  template
  ProgramTemplate
  AssignView
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
            id: 'assign'
            title: 'Assign'
        ]

      privacy_widget:
        model: -> @view.model.get('data.model')

      add_to_library:
        model: -> @view.model.get('data.model')

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    init: ->
      @model.set('state', @options.state)

    initModel: ->
      new ProgramTemplate
        id: @options.id

    initViews: ->
      overview: ->
        new Marionette.View
      assign: ->
        new AssignView
          model: @model.get('data.model')
