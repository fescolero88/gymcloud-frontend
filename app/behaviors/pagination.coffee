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

    onShow: ->
      @view.getRegion('pagination').show(@paginationView)