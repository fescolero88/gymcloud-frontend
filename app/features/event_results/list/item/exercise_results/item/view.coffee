define [
  './template'
  'features/event_results/list/item/exercise_properties/view'
], (
  template
  ExercisePropertiesCollectionView
) ->

  class ExerciseResultView extends Marionette.LayoutView

    template: template

    className: 'row middle-item'

    behaviors:

      regioned:
        views: [
            region: 'exercise_properties'
            klass: ExercisePropertiesCollectionView
            options: ->
              collection: new Backbone.Collection([{}, {}])
        ]


