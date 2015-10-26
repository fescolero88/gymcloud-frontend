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

    behaviors:

      stickit:
        bindings:
          '.gc-clients-list-avatar-wrapper':
            attributes: [
                observe: 'avatar_background_color'
                name: 'style'
                onGet: (val) ->
                  (val && "background-color: #{val}") || ''
            ]
          '.glyphicon-ok':
            attributes: [
                observe: ['assigned_count', 'is_assigned']
                name: 'class'
                onGet: ([assigned_count, is_assigned]) ->
                  cssClass = ''
                  unless is_assigned
                    cssClass = if assigned_count then 'partial' else 'hidden'
                  "glyphicon glyphicon-ok #{cssClass}"
            ]

    initialize: (options) ->
      @entity = options.entity
      @entityType = options.entityType

    toggleAssign: (ev) =>
      if @model.get('is_assigned')
        App.request 'base:confirmationalModal',
          title: "Unassign #{@entityType}?"
          content: "Are you sure you want unassign #{@entityType} from group?"
          confirmBtn: 'Unassign'
          confirmCallBack: =>
            @model.unassign(@entity).then (response) =>
              @model.set(response)
              @_toggleAssignSuccess('unassign')
      else
        @model.assign(@entity).then (response) =>
          @model.set(response)
          @_toggleAssignSuccess('assign')

    _toggleAssignSuccess: (actionType) ->
      if actionType is 'assign'
        message = "This #{@entityType} is assigned to group"
      else
        message = "This #{@entityType} is unassigned from group"

      App.request('messenger:show', message: message)
      @render()
