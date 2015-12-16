define [
  './template'
  './item/view'
  './collection'
], (
  template
  ItemView
  Collection
) ->

  class View extends Marionette.CompositeView

    template: template

    className: 'gc-program-actions'

    childView: ItemView

    childViewContainer: 'ul'

    initialize: ->
      @collection = new Collection(@options.items)
