define [
  'backbone'
  'backbone.marionette'
  './item/view'
], (
  Backbone
  Marionette
  ItemView
) ->

  class View extends Marionette.CollectionView

    tagName: 'ul'

    className: 'gc-content-nav'

    childView: ItemView
