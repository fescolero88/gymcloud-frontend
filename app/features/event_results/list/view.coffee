define [
  './item/view'
], (
  EventExerciseItemView
) ->

  class EventExerciseResultCollectionView extends Marionette.CollectionView

    className: 'gc-box-content'

    childView: EventExerciseItemView

    initialize: ->
      @collection = @model.exercises
