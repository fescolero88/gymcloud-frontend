define [
  './template'
  './item/view'
], (
  template
  StatsItemView
) ->
  class StatsCompositeView extends Marionette.CompositeView

    template: template

    childView: StatsItemView

    childViewContainer: '.stats-collection-container'

    className: 'gc-main-workspace row'
