define [
  './item/view'
  './template'
], (
  ItemView
  template
) ->

  class ClientPerformanceCollectionView extends Marionette.CompositeView

    className: 'tab-content'

    childViewContainer: 'tbody'
