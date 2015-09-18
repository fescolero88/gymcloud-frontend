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
      'assignedVersion'
      'isAssigned'
      'isOutdated'
      'workout'
      'clientAssignees'
    ]

    templateHelpers: =>
      helpers = { isMe: @_isMe() }
      for option in @assignOptions
        helpers[option] = this[option]
      helpers

    initialize: (options) ->
      for option in @assignOptions
        this[option] = options[option]
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
        @_toggleAssignSuccess(null, 'unassign')

    _assign: ->
      @assignment = new PersonalWorkout
        person_id: @model.id
        workout_template_id: @workout.id

      @assignment.save().then =>
        currentUser = App.request('current_user')
        if @model.id == App.request('current_user_id')
          currentUser.personal_workouts.add(@assignment)

        @isAssigned = true
        @isOutdated = false
        @assignedVersion = @workout.get('version')
        @clientAssignees.add(@assignment)
        @_toggleAssignSuccess(null, 'assign')

    _toggleAssignSuccess: (_response, actionType) ->
      message = "This workout was #{actionType}ed to this client"
      App.request 'messenger:show',
        message: message
      @render()
