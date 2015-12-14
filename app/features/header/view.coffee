define [
  './template'
], (
  template
) ->

  class HeaderView extends Marionette.LayoutView

    template: template

    regions:
      searchBar: 'region[data-name="search-bar"]'

    initialize: ->
      @listenTo(App.vent, 'profile:ready', @render)

    onRender: ->
      App.vent.trigger('app:view:header:render', @)

    onDestroy: ->
      App.vent.trigger('app:view:header:destroy', @)
