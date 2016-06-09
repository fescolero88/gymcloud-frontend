define [
  './template'
  './exercise_properties/view'
  './exercise_results/view'
  './new_exercise_result/view'
  './comments/view'
], (
  template
  ExercisePropertiesCollectionView
  ExerciseResultCollectionView
  NewExerciseResultView
  CommentsLayoutView
) ->

  class EventExerciseItemView extends Marionette.LayoutView

    template: template

    className: 'gc-workout-enter-result-view'

    behaviors: ->

      stickit:

        bindings:
          '.gc-workout-exercise-circle': 'order_name'
          '.gc-workout-exercise-name': 'name'
          '.details-section span': 'note'
          '.details-section span':
            observe: 'note'
            visible: true

      regioned:
        views: [
            region: 'exercise_properties'
            klass: ExercisePropertiesCollectionView
            options: ->
              collection: @model.properties
          ,
            region: 'exercise_result_items'
            klass: ExerciseResultCollectionView
            options: ->
              collection: @model.exercise_results
          ,
            region: 'new_exercise_result'
            klass: NewExerciseResultView
          ,
            region: 'comments'
            klass: CommentsLayoutView
            options: ->
              collection: new Backbone.Collection([{}, {}])
        ]
