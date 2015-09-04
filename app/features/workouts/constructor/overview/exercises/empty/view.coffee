define [
  'backbone.marionette'
  './template'
], (
  Marionette
  template
) ->

  class EmptyWorkoutExerciseView extends Marionette.ItemView

    template: template