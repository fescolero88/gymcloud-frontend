define [
  './template'
], (
  template
) ->

  class ItemView extends Marionette.ItemView

    tagName: 'tr'

    template: template

    templateHelpers: ->
      withStatus: @options.withStatus

    behaviors: ->
      stickit:
        bindings:
          '.performed-workout-link': 'workout_name'
          '.date':
            observe: 'begins_at'
            onGet: (value) ->
              moment(value).format('MMM DD')
          '.time':
            observe: 'begins_at'
            onGet: (value) ->
              moment(value).format('HH:mm A')
