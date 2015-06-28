Backbone = require 'backbone'

class ClientModel extends Backbone.Model
  defaults:
    client_ids: []
    client_group_ids: []

  url: (actionType) ->
    switch actionType
      when 'assign'
        "/api/mobile/workouts/#{@id}/assignees/bulk_assign"
      when 'unassign'
        "/api/mobile/workouts/#{@id}/assignees/bulk_unassign"
      else
        throw new Error('invalid action type')

  toggleAssign: ->
    actionType = if @get('isAssigned') then 'unassign' else 'assign'

    options =
      url: @url(actionType)
      data: JSON.stringify @toJSON()

    options = App.request 'ajax:options:create', options

    (@sync || Backbone.sync).call(@, null, @, options)
      .then (response) =>
        @trigger 'model:toggle_assign:success', response
      .fail (xhr, textStatus, errorThrown) =>
        @trigger 'model:toggle_assign:fail', 'Something went wrong'


module.exports = class ClientCollection extends Backbone.Collection
  model: ClientModel

  url: '/api/mobile/clients'
