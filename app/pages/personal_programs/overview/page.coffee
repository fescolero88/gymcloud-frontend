define [
  'pages/base/page'
  './template'
  'models/personal_program'
  './overview/view'
], (
  BasePage
  template
  PersonalProgram
  OverviewView
) ->

  class Page extends BasePage

    behaviors:

      navigate_back: true

      breadcrumbs:
        model: -> @view.model.get('data.model')

      program_action_panel:
        readonly: true
        model: -> @view.model.get('data.model')

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    init: ->
      @model.set('state.subpage', @options.state)

    initModel: ->
      new PersonalProgram
        id: @options.id

    initViews: ->
      overview: ->
        new OverviewView
          model: @model.get('data.model')
