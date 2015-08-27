define [
  'backbone'
], (
  Backbone
) ->

  class SearchResults extends Backbone.Collection

    url: '/api/mobile/search'
