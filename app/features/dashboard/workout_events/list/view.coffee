define [
  './item/view'
  './template'
], (
  ItemView
  template
) ->

  class WorkoutEventsTableView extends Marionette.CompositeView

    className: 'tab-content'

    template: template

    templateHelpers: ->
      withStatus: @options.withStatus

    childView: ItemView

    childViewContainer: 'tbody'

    childViewOptions: ->
      withStatus: @options.withStatus
