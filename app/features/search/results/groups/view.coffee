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

    childView: ItemView
