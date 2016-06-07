define [
  './template'
  './new_exercise_result_items/view'
], (
  template
  NewExerciseResultItemsCollectionView
) ->

  class NewExerciseResultView extends Marionette.LayoutView

    className: 'workout-enter-results opened'

    template: template

    behaviors:

      regioned:
        views: [
            region: 'new_exercise_result_items'
            klass: NewExerciseResultItemsCollectionView
            options: ->
              collection: new Backbone.Collection([{}, {}])
        ]
