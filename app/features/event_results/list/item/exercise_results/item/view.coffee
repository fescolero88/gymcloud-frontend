define [
  './template'
  'features/event_results/list/item/exercise_properties/view'
  'moment'
], (
  template
  ExercisePropertiesCollectionView
  moment
) ->

  class ExerciseResultView extends Marionette.LayoutView

    template: template

    className: 'row middle-item'

    behaviors: ->

      stickit:
        bindings:
          '.workout-enter-prev-result span:last':
            observe: 'created_at'
            onGet: (value) ->
              moment(value).format('YY/MM/DD HH:mm')

      regioned:
        views: [
            region: 'exercise_properties'
            klass: ExercisePropertiesCollectionView
            options: ->
              collection: @model.exercise_result_items
        ]
