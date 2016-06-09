define [
  'pages/base/page'
  './template'
  'features/event_results/list/view'
], (
  BasePage
  template
  EventExerciseResultCollectionView
) ->

  class EventResultsPage extends BasePage

    behaviors:

      navigate_back: true

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    initViews: ->
      root: ->
        new EventExerciseResultCollectionView
