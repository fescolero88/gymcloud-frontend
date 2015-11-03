define [
  './template'
], (
  template
) ->

  class ExercisePropertyItem extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'gc-workout-exercise-prop'
