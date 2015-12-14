define [
  'features/programs/constructor/overview/workouts/view'
], (
  OldWorkoutListView
) ->
  class WorkoutListView extends OldWorkoutListView

    addChild: (child, ChildView, index) ->
      Marionette.CollectionView::addChild.apply @, arguments
