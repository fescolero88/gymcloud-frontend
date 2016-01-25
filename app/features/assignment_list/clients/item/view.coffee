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
      'clientAssignees'
    ]

    templateHelpers: =>
      isMe: @_isMe()
      isOutdated: @isOutdated
      isAssigned: @isAssigned

    initialize: (options) ->
      for option in @assignOptions
        @[option] = options[option]

      type = _.underscored(@entity.type)
      @assignedVersion = @assignment?.get("#{type}_template_version")
      @isAssigned = !!@assignment
      @isOutdated = @entity.get('version') > @assignedVersion

      @

    toggleAssign: (ev) =>
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
      @entity.assignTo(@model).then (response) =>
        @assignment = new PersonalWorkout(response)
        @isAssigned = true
        @isOutdated = false
        @assignedVersion = @entity.get('version')
        @clientAssignees.add(@assignment)
        @_toggleAssignSuccess('assign')

    _toggleAssignSuccess: (actionType) ->
      type = @entity.type
      if actionType is 'assign'
        App.request('messenger:explain', 'item.client.assigned', type: type)
      else
        App.request('messenger:explain', 'item.client.unassigned', type: type)
      @render()
