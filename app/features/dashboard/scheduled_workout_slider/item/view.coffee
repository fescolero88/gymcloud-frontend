define [
  './template'
], (
  template
) ->

  class ScheduledWorkoutSliderItemView extends Marionette.ItemView

    template: template

    className: 'item'

    triggers:
      'click .owl-prev': 'owl:prev'
      'click .owl-next': 'owl:next'

    behaviors: ->
      stickit:
        bindings:
          '.workout-link': 'workout_name'
          '.date':
            observe: 'begins_at'
            onGet: (value) ->
              moment(value).format('MMM DD')
          '.time':
            observe: 'begins_at'
            onGet: (value) ->
              moment(value).format('HH:mm A')
