define [
  'backbone'
], (
  Backbone
) ->

  class ClientGroupModel extends Backbone.Model

    defaults:
      client_ids: []
      client_group_ids: []

    url: (actionType) ->
      workoutId = @get 'workoutId'
      switch actionType
        when 'assign'
          "/api/mobile/workouts/#{workoutId}/assignees/bulk_assign"
        when 'unassign'
          "/api/mobile/workouts/#{workoutId}/assignees/bulk_unassign"
        else
          throw new Error('invalid action type')

    toggleAssign: ->
      actionType = if @get('isAssigned') then 'unassign' else 'assign'
      @set('client_group_ids', [@get('id')])

      options =
        url: @url(actionType)
        data:
          JSON.stringify
            client_ids: @get 'client_ids'
            client_group_ids: @get 'client_group_ids'

      options = App.request 'ajax:options:create', options

      (@sync || Backbone.sync).call(@, null, @, options)
        .then (response) =>
          @set('isAssigned', !@get('isAssigned'))
          @trigger 'model:toggle_assign:success', response, actionType
        .fail (xhr, textStatus, errorThrown) =>
          @trigger 'model:toggle_assign:fail', 'Something went wrong'

  class ClientGroups extends Backbone.Collection

    model: ClientGroupModel
    url: '/users'
