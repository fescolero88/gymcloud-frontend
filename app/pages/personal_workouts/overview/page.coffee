define [
  'pages/base/page'
  './template'
  'models/personal_workout'
  './overview/view'
], (
  BasePage
  template
  PersonalWorkout
  OverviewView
) ->

  class Page extends BasePage

    behaviors:

      navigate_back: true
      mobile_only_features: true
      stickit:
        model: ->
          @model.get('data.model')
        bindings:
          'span.name': 'name'

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    initModel: ->
      new PersonalWorkout
        id: @options.id

    initViews: ->
      overview: ->
        new OverviewView
          model: @model.get('data.model')
