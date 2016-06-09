define [
  './item/view'
  './collection'
], (
  EventExerciseItemView
  EventExercisesCollection
) ->

  class EventExerciseResultCollectionView extends Marionette.CollectionView

    className: 'gc-box-content'

    childView: EventExerciseItemView

    initialize: ->
      @collection = new EventExercisesCollection([{}])
