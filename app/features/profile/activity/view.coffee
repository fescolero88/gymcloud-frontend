define [
  './empty/view'
  './item/view'
  './template'
], (
  EmptyView
  ItemView
  template
) ->
  class ActivityView extends Marionette.CompositeView

    template: template

    emptyView: EmptyView

    childView: ItemView

    childViewContainer: 'ul'

    events:
      'click @ui.loadMore': 'loadMore'

    ui:
      loadMore: '.load-more'

    templateHelpers: ->
      noMore: @collection?.noMore

    loadMore: (ev) ->
      ev.preventDefault()
      @collection.loadMore()

    refresh: (ev) ->
      @collection.page = 0
      @collection.prevLength = 0
      @collection.loadMore(true)
