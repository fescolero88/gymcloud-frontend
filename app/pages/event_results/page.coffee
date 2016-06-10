define [
  'pages/base/page'
  './template'
  'features/event_results/list/view'
  'models/workout_event'
], (
  BasePage
  template
  EventExerciseResultCollectionView
  WorkoutsEvent
) ->

  class EventResultsPage extends BasePage

    behaviors:

      navigate_back: true

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    initModel: ->
      new WorkoutsEvent
        id: @options.id

    initViews: ->
      root: ->
        new EventExerciseResultCollectionView
          model: @model.get('data.model')
