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
