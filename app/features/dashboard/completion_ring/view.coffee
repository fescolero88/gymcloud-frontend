define [
  './model'
  './template'
], (
  Model
  template
) ->

  class CompletionRingView extends Marionette.ItemView

    template: template

    behaviors: ->
      stickit:
        bindings:
          '.counter': 'name'
          '.counter-text': 'description'
          '.progress':
            attributes: [
                name: 'style'
                observe: ['progress', 'progress_max']
                onGet: (values) ->
                  parts = ['stroke-dasharray:'].concat(values)
                  parts.join(' ')
            ]

    initialize: ->
      event = @options.event

      @model = new Model _.extend {}, @options,
        completed: event.get('completed_count')
        total: event.get('scheduled_count')

      @listenTo event, 'change', ->
        @model.set
          completed: event.get('completed_count')
          total: event.get('scheduled_count')
