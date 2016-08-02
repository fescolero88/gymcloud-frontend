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
      @model = new Model(@options)