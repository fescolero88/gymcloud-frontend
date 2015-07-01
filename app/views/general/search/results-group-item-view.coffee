Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ResultsEntityItemView = require 'views/general/search/results-entity-item-view'
ResultsClientItemView = require 'views/general/search/results-client-item-view'
ResultsClientGroupItemView = require 'views/general/search/results-client-group-item-view'

templateEntity = require('templates/general/search/group_for_entity')
templateClients = require('templates/general/search/group_for_clients')

module.exports = class ResultsGroupItemView extends Marionette.CompositeView
  tagName: 'ul'
  className: 'gc-search-results-list'

  initialize: (opts)->
    @collection = new Backbone.Collection(opts.model.get('items'))

  getTemplate: ->
    map =
      'Exercises': templateEntity
      'Workouts': templateEntity
      'Programs': templateEntity
      'Clients': templateClients
      'Client Groups': templateClients
    type = @model.get('title')
    map[type]

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
