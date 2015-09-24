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
      if actionType is 'assign'
        message = "This #{@entityType} is assigned to client"
      else
        message = "This #{@entityType} is unassigned from client"

      App.request('messenger:show', message: message)
      @render()