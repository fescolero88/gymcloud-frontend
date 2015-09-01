define [
  'backbone'
  'backbone.marionette'
  './template'
], (
  Backbone
  Marionette
  template
) ->

  class HeaderView extends Marionette.LayoutView

    template: template

    regions:
      searchBar: 'region[data-name="search-bar"]'

    initialize: ->
      App.vent.on('profile:ready', @render)

    onRender: ->
      App.vent.trigger('app:view:header:render', @)

    onDestroy: ->
      App.vent.trigger('app:view:header:destroy', @)
      App.vent.off('profile:ready', @render)
