define [
  'models/personal_workout'
  './template'
], (
  PersonalWorkout
  template
) ->

  class ClientItemView extends Marionette.ItemView

    tagName: 'li'

    template: template

    className: 'row gc-workout-client-item'

    events:
      'click': 'toggleAssign'

    assignOptions: [
      'assignment'
      'entity'
      'entityType'
      'clientAssignees'
    ]

    templateHelpers: =>
      isMe: @_isMe()
      isOutdated: @isOutdated
      isAssigned: @isAssigned

    initialize: (options) ->
      for option in @assignOptions
        this[option] = options[option]

      @assignedVersion = @assignment?.get("#{@entityType}_template_version")
      @isAssigned = !!@assignment
      @isOutdated = @entity.get('version') > @assignedVersion

      this

    toggleAssign: (ev) =>
      ev.preventDefault()
      if @isAssigned then @_unassign() else @_assign()
      @triggerMethod('assignees:changed')

    _isMe: ->
      @model.id == App.request('current_user_id')

    _unassign: ->
      @assignment.destroy().then =>
        @assignment = null
        @assignedVersion = null
        @isOutdated = null
        @isAssigned = false
        @_toggleAssignSuccess('unassign')

    _assign: ->
      @entity.assignTo(@model).then (assignment) =>
        @assignment = assignment
        @isAssigned = true
        @isOutdated = false
        @assignedVersion = @entity.get('version')
        @clientAssignees.add(@assignment)
        @_toggleAssignSuccess('assign')

    _toggleAssignSuccess: (actionType) ->
      message = "This #{@entityType} was #{actionType}ed to this client"
      App.request 'messenger:show',
        message: message
      @render()