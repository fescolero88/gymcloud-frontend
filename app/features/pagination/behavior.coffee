define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  PaginationView
) ->

  class PaginationBehavior extends BaseRegionedBehavior

    regionName: 'pagination'

    behaviorViewClass: PaginationView

    behaviorViewOptions: ->
      collection: @view.collection

    onShow: ->
      @listenTo(@view.collection, 'request', @_changeVisibility)

    _changeVisibility: ->
      if @view.collection.isEmpty()
        @behaviorView.$el.hide()
      else
        @behaviorView.$el.show()
