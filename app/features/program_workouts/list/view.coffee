define [
  #'./template'
  './item/view'
  './empty/view'
], (
  #template
  ItemView
  EmptyView
) ->

  class ProgramWorkoutsListView extends Marionette.CollectionView

    #template: template

    className: 'gc-program-workouts-list'

    childView: ItemView

    emptyView: EmptyView

    viewComparator: (model) ->
      model.get('position')
