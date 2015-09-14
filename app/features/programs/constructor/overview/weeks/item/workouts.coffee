define [
  '../../workouts/view'
], (
  OldWorkoutListView
) ->
  class WorkoutListView extends OldWorkoutListView

    addChild: (child, ChildView, index) ->
      Marionette.CollectionView::addChild.apply this, arguments