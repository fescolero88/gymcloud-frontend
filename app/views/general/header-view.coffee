Marionette = require 'backbone.marionette'
Backbone = require 'backbone'
SearchBarView = require 'views/general/search/search-bar-view'

module.exports = class HeaderView extends Marionette.LayoutView

  template: Templates.general.header

  ui:
    searchRegion: 'region[data-name="search-bar"]'
  
  regions:
    searchControl: "@ui.searchRegion"

  initialize: ->
    App.vent.on 'profile:ready', @render

  onRender: ->
    searchBarView = new SearchBarView
    @getRegion('searchControl').show searchBarView

  onDestroy: =>
    App.vent.off 'profile:ready', @render
