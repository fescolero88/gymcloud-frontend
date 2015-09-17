define [
  './item/view'
], (
  BreadcrumbsItemView
) ->

  class BreadcrumbsView extends Marionette.CollectionView

    tagName: 'h2'

    className: 'gc-breadcrumbs-title'

    childView: BreadcrumbsItemView

    childViewOptions: (model, index) ->
      isEditable = !!model.get('folder_id')
      options = { isEditable: isEditable }
      options.attributes = { contenteditable: isEditable } if isEditable
      options

    initialize: (options) ->
      @collection = new Backbone.Collection
      @_getBreadcrumbs(@model)

    reinitCollection: ->
      @collection.reset()
      @_getBreadcrumbs(@model)

    _getBreadcrumbs: (model) ->
      @collection.unshift(model)
      parent = model.parent
      @_getBreadcrumbs(parent) if parent?.get('parent_id') != null
