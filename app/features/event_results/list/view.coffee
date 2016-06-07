define [
  './item/view'
  './collection'
], (
  EventExerciseItemView
  EventExercisesCollection
) ->

  class EventExerciseResultCollectionView extends Marionette.CollectionView

    tagName: 'list'

    className: 'gc-box-content exercise-results'

    childView: EventExerciseItemView

    initialize: ->
      @collection = new EventExercisesCollection([{}])
