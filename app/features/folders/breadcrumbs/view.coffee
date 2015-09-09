define [
  'backbone.marionette'
  './item/view'
], (
  Marionette
  BreadcrumbsItemView
) ->

  class BreadcrumbsView extends Marionette.CollectionView

    tagName: 'h2'

    className: 'gc-breadcrumbs-title'

    childView: BreadcrumbsItemView

    initialize: (options) ->
      @collection = new Backbone.Collection
      @_getBreadcrumbs(@model)

    _getBreadcrumbs: (model) ->
      name = model.get('name')
      @collection.unshift(title: name)
      parent = model.parent
      @_getBreadcrumbs(parent) if parent?.get('parent_id') != null