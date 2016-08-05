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
                  ['stroke-dasharray:'].concat(values).join(' ')
            ]

    initialize: ->
      event = @options.event

      @model = new Model _.extend {}, @options,
        completed: event.get('completed_count')
        total: event.get('scheduled_count')

      @listenTo event, 'change:completed_count change:scheduled_count', ->
        @model.set
          completed: event.get('completed_count')
          total: event.get('scheduled_count')
