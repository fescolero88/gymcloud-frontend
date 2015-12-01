define ->

  class ClientGroupService extends Backbone.Model

    url: '/client_groups/{groupId}/members/{clientId}'

    defaults:
      clientIds: []
      clientGroupIds: []

    _createUrl: (groupId, clientId) ->
      @url.replace('{groupId}', groupId).replace('{clientId}', clientId)

    assignClients: ->
      promises = []
      @get('clientGroupIds').forEach (groupId) =>
        @get('clientIds').forEach (clientId) =>
          promise = $.post @_createUrl(groupId, clientId)
          promises.push promise

      $.when.apply($, promises).done =>
        @trigger 'clients:assigned'
