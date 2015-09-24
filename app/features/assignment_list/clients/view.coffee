define [
  './item/view'
  './template'
], (
  ClientItemView
  template
) ->

  class AssignClientsListView extends Marionette.CompositeView

    template: template

    className: 'gc-clients-list-wrapper gc-assign-list'

    childView: ClientItemView

    childViewContainer: 'ul.gc-clients-list'

    childViewOptions: (client, _index) ->
      options =
        assignment: @_getAssigmentBy(client)
        entity: @entity
        entityType: @entityType
        clientAssignees: @clientAssignees
      if client.id == App.request('current_user_id')
        options.attributes = style: 'background-color: #E3F2FD'
      options

    childEvents:
      'assignees:changed': @_flushCache

    viewComparator: (model) ->
      if model.id == App.request('current_user_id')
        0 # will be first
      else
        model.id

    initialize: (options) ->
      @clientAssignees = options.clientAssignees
      @entity = options.entity
      @entityType = options.entityType

    _flushCache: =>
      # flush memoize cache of _getAssigmentBy function
      @_getAssigmentBy.cache.__data__ = {}

    _getAssigmentBy: _.memoize (user) ->
      @clientAssignees.findWhere(person_id: user.id)