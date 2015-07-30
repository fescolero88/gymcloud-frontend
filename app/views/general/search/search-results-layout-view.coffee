Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ResultsGroupsCollectionView = require 'views/general/search/results-groups-collection-view'
ResultsGroupItemView = require 'views/general/search/results-group-item-view'
AuthorScopeCollectionView = require 'views/general/search/author-scope-collection-view'
SearchFilterCollectionView = require 'views/general/search/search-filter-collection-view'

module.exports = class SearchResultsLayoutView extends Marionette.LayoutView

  className: 'gc-search-results-main'

  template: require('templates/general/search/search_results_layout')

  initialize: ->
    q = @model.get 'q'
    entityType = @model.get 'entity_type'
    searchScope = @model.get 'search_scope'

    @searchScopesCollection = new Backbone.Collection [
      { name: 'all', value: 'all', inScope: searchScope == 'all' }
      { name: 'gymcloud', value: 'public', inScope: searchScope == 'public' }
      { name: 'own', value: 'own', inScope: searchScope == 'own' }
    ]

    @searchFiltersCollection = new Backbone.Collection [
      { name: 'All', isSelected: entityType == 'all', href: "#search/#{q}" }
      { name: 'Exercises', isSelected: entityType == 'exercises', href: "#search/#{q}/exercises" }
      { name: 'Workouts', isSelected: entityType == 'workouts', href: "#search/#{q}/workouts" }
      { name: 'Programs', isSelected: entityType == 'programs', href: "#search/#{q}/programs" }
      { name: 'Clients', isSelected: entityType == 'clients', href: "#search/#{q}/clients" },
      { name: 'Client Groups', isSelected: entityType == 'client_groups', href: "#search/#{q}/client_groups" }
    ]

  regions:
    searchScope: 'region[data-name="author-scope"]'
    resultGroups: 'region[data-name="search-results"]'
    searchFilters: 'region[data-name="search-filters"]'

  onShow: ->
    @getRegion('resultGroups').show new ResultsGroupsCollectionView
      collection: @collection

    @getRegion('searchScope').show new AuthorScopeCollectionView
      collection: @searchScopesCollection
      model: @model

    @getRegion('searchFilters').show new SearchFilterCollectionView
      collection: @searchFiltersCollection

