define [
  'pages/base/page'
  './template'
  'features/event_results/view'
  'models/workout_event'
  'moment'
], (
  BasePage
  template
  EventExerciseResultCollectionView
  WorkoutsEvent
  moment
) ->

  class EventResultsPage extends BasePage

    className: 'gc-event-results'

    behaviors: ->

      navigate_back: true

      stickit:
        model: -> @model.get('data.model')
        bindings:
          '.name': 'workout_name'
          '.date':
            observe: 'begins_at'
            onGet: (dateTime) ->
              return '' unless dateTime
              moment(dateTime).format('MM/DD/YYYY h:mm A')
          '.prev': classes:
            disabled:
              observe: 'prev_id'
              onGet: (id) -> !id
          '.next': classes:
            disabled:
              observe: 'next_id'
              onGet: (id) -> !id
          '.prev a': attributes: [
              name: 'href'
              observe: 'prev_id'
              onGet: @_siblingEventUrl
          ]
          '.next a': attributes: [
              name: 'href'
              observe: 'next_id'
              onGet: @_siblingEventUrl
          ]

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

    _siblingEventUrl:  (id) ->
      return '#' unless id
      "/#events/#{id}/results"
