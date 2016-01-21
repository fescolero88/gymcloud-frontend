define [
  'pages/base/page'
  './template'
  'models/program_template'
  'features/assignment_list/view'
  './overview/view'
], (
  BasePage
  template
  ProgramTemplate
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
            id: 'assign'
            title: 'Assign'
        ]

      program_action_panel:
        model: -> @view.model.get('data.model')

      privacy_widget:
        model: -> @view.model.get('data.model')

      add_to_library:
        model: -> @view.model.get('data.model')

      actions_dropdown:
        model: -> @view.model.get('data.model')
        items: [
            label: 'Add Note'
          ,
            label: 'Edit Description'
          ,
            label: 'Add Video'
          ,
            label: 'Delete'
            className: 'text-danger'
        ]

      redirect_back_on_destroy:
        model: -> @view.model.get('data.model')

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    init: ->
      @model.set('state.subpage', @options.state)

    initModel: ->
      new ProgramTemplate
        id: @options.id

    initViews: ->
      overview: ->
        new OverviewView
          model: @model.get('data.model')
      assign: ->
        new AssignView
          model: @model.get('data.model')
