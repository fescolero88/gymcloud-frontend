define [
  'models/personal_workout'
  './template'
], (
  PersonalWorkout
  template
) ->

  class GroupItemView extends Marionette.ItemView

    tagName: 'li'

    template: template

    className: 'row gc-workout-client-item'

    events:
      'click': 'toggleAssign'

    initialize: (options) ->
      @entity = options.entity
      @entityType = options.entityType

    toggleAssign: (ev) =>
      action = if @model.get('is_assigned') then 'unassign' else 'assign'
      @model[action](@entity).then (response) =>
        @model.set(response)
        @_toggleAssignSuccess(action)

    _toggleAssignSuccess: (actionType) ->
      if actionType is 'assign'
        message = "This #{@entityType} is assigned to group"
      else
        message = "This #{@entityType} is unassigned from group"

      App.request('messenger:show', message: message)
      @render()
