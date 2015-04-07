Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ResultsEntityItemView = require 'views/general/search/results-entity-item-view'
ResultsClientItemView = require 'views/general/search/results-client-item-view'
ResultsClientGroupItemView = require 'views/general/search/results-client-group-item-view'

module.exports = class ResultsGroupItemView extends Marionette.CompositeView
  tagName: 'ul'
  className: 'gc-search-results-list'

  initialize: (opts)->
    @collection = new Backbone.Collection(opts.model.get('items'))

  getTemplate: ->
    map =
      'Exercises': 'group_for_entity'
      'Workouts': 'group_for_entity'
      'Programs': 'group_for_entity'
      'Clients': 'group_for_clients'
      'Client Groups': 'group_for_clients'
    type = @model.get('title')
    templateKey = map[type]
    Templates.general.search[templateKey]

  childViewOptions: ->
    entity_context: @model.get('title').toLowerCase()

  getChildView: (item)->
    map =
      'Exercises': ResultsEntityItemView
      'Workouts': ResultsEntityItemView
      'Programs': ResultsEntityItemView
      'Clients': ResultsClientItemView
      'Client Groups': ResultsClientGroupItemView
    type = @model.get('title')
    map[type]
