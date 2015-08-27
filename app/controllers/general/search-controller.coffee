Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

SearchResultsLayoutView = require 'views/general/search/search-results-layout-view'
SearchResults = require 'collections/search_results'

module.exports = class SearchController extends Marionette.Controller

  initialize: (options) ->
    #@mainView = options.mainView
    App.vent.on 'search:initMainView', (view) =>
      @mainView = view
    App.vent.on 'search:global', (q, entityType = 'all', searchScope = 'all') =>
      Backbone.history.navigate "search/#{q}/#{entityType}/#{searchScope}", { trigger: true }

  search: (q, entityType = 'all', searchScope='all') =>
    searchCollection = new SearchResults
    searchParams =
      q: q #query
      entity_type: entityType #exercises, workouts, programs, client_n_groups or all
      search_scope: searchScope
    searchView = new SearchResultsLayoutView
      collection: searchCollection
      model: new Backbone.Model(searchParams)
    @mainView.content.show(searchView)

    searchCollection.fetch
      data: searchParams
