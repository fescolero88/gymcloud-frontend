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
          '.personal-best-check':
            classes:
              active: 'is_personal_best'
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

    events:
      'click .personal-best-check': '_changeIsPersonalBest'

    _changeIsPersonalBest: ->
      @model.patch(is_personal_best: !@model.get('is_personal_best'))