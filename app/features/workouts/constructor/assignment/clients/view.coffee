define [
  './item/view'
  './template'
], (
  ClientItemView
  template
) ->

  class WorkoutGlobalAssignClientsListView extends Marionette.CompositeView

    template: template

    className: 'gc-clients-list-wrapper gc-workouts-assign-list'

    childView: ClientItemView

    childViewContainer: 'ul.gc-clients-list'

    childViewOptions: (client, _index) ->
      options =
        assignment: @_getAssigmentBy(client)
        assignedVersion: @_assignedVersionFor(client)
        isAssigned: @_isAssignedTo(client)
        isOutdated: @_isOutdatedFor(client)
        workout: @workout
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
      @workout = options.workout

    _flushCache: =>
      # flush memoize cache of _getAssigmentBy function
      @_getAssigmentBy.cache.__data__ = {}

    _getAssigmentBy: _.memoize (user) ->
      @clientAssignees.findWhere(person_id: user.id)

    _assignedVersionFor: (user) ->
      assignment = @_getAssigmentBy(user)
      assignment?.get('workout_template_version')

    _isOutdatedFor: (user) ->
      assignment = @_getAssigmentBy(user)
      @workout.get('version') > @_assignedVersionFor(user)

    _isAssignedTo: (user) ->
      !!@_getAssigmentBy(user)
