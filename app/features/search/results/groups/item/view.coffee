define [
  './templates/entity'
  './templates/clients'
  '../../entities/item'
  '../../entities/client'
  '../../entities/client_group'
], (
  templateEntity
  templateClients
  ResultEntityItemView
  ResultEntityClientView
  ResultEntityClientGroupView
) ->

  class View extends Marionette.CompositeView

    tagName: 'ul'

    className: 'gc-search-results-list'

    initialize: (opts)->
      @collection = new Backbone.Collection(opts.model.get('items'))

    getTemplate: ->
      @_templatesMap()[@model.get('klass')]

    getChildView: (item)->
      @_childViewsMap()[@model.get('klass')]

    childViewOptions: ->
      entity_context: @model.get('title').toLowerCase()

    _templatesMap: ->
      'Exercise': templateEntity
      'WorkoutTemplate': templateEntity
      'ProgramTemplate': templateEntity
      'User': templateClients
      'ClientGroup': templateClients

    _childViewsMap: ->
      'Exercise': ResultEntityItemView
      'WorkoutTemplate': ResultEntityItemView
      'ProgramTemplate': ResultEntityItemView
      'User': ResultEntityClientView
      'ClientGroup': ResultEntityClientGroupView
