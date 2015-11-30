define [
  'features/pagination/view'
], (
  PaginationView
) ->

  class PaginationBehavior extends Marionette.Behavior

    initialize: ->
      @view.addRegion('pagination', 'region[data-name="pagination"]')
      @paginationView = new PaginationView(
        collection: @view.collection
      )
      @listenTo(@view.collection, 'request', @_changeVisibility)

    onShow: ->
      @view.getRegion('pagination').show(@paginationView)

    _changeVisibility: ->
      if @view.collection.isEmpty()
        @paginationView.$el.hide()
      else
        @paginationView.$el.show()