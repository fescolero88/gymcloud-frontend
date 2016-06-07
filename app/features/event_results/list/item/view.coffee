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

    behaviors:

      regioned:
        views: [
            region: 'exercise_properties'
            klass: ExercisePropertiesCollectionView
            options: ->
              collection: new Backbone.Collection([{}, {}])
          ,
            region: 'exercise_result_items'
            klass: ExerciseResultCollectionView
            options: ->
              collection: new Backbone.Collection([{}, {}])
          ,
            region: 'new_exercise_result'
            klass: NewExerciseResultView
            options: ->
              collection: new Backbone.Collection([{}, {}])
          ,
            region: 'comments'
            klass: CommentsLayoutView
            options: ->
              collection: new Backbone.Collection([{}, {}])
        ]
