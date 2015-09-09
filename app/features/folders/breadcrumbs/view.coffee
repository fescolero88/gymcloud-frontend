define [
  'backbone.marionette'
  './item/view'
  './template'
], (
  Marionette
  BreadcrumbsItemView
  template
) ->

  class BreadcrumbsView extends Marionette.CompositeView

    template: template

    childView: BreadcrumbsItemView

    childViewContainer: 'h2'

    initialize: (options) ->
      @collection = new Backbone.Collection
      @_getBreadcrumbs(@model)

    _getBreadcrumbs: (model) ->
      name = model.get('name')
      @collection.unshift(title: name)
      parent = model.parent
      @_getBreadcrumbs(parent) if parent