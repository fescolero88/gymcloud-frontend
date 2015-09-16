define [
  'models/user'
], (
  User
) ->

  class ClientGroup extends Backbone.Model

    urlRoot: '/client_groups'

    validation:

      name:
        required: true

    updateAvatar: (formData) ->

      options =
        url: "#{@urlRoot}/#{@id}/avatar"
        type: 'PUT'
        data: formData
        processData: false
        contentType: false

      (@sync || Backbone.sync).call(@, null, @, options)
        .then (response) =>
          @trigger 'model:avatar_update:success', response
        .fail (xhr, textStatus, errorThrown) =>
          @trigger 'model:avatar_update:fail', 'Something went wrong'

    addUser: (user) ->
      options =
        url: "#{@url()}/members/#{user.id}"
        type: 'POST'
        data: ''
        processData: false

      request = (@sync || Backbone.sync).call(@, null, @, options)
      request
        .then (response) =>
          @clients.add(user)
          @trigger 'user:add:success', response
        .fail (xhr, textStatus, errorThrown) =>
          @trigger 'user:add:error', arguments
      request

    removeUser: (user) ->
      options =
        url: "#{@url()}/members/#{user.id}"
        type: 'DELETE'
        data: ''
        processData: false

      request = (@sync || Backbone.sync).call(@, null, @, options)
      request
        .then (response) =>
          @clients.remove(user)
          @trigger 'user:remove:success', response
        .fail (xhr, textStatus, errorThrown) =>
          @trigger 'user:remove:error', arguments
      request

    parse: (data) ->
      @_parseClients(data.clients) && delete data.clients
      data

    _parseClients: (clients) ->
      currentUser = App.request('current_user')
      clients = _.map clients, (user) ->
        clientCollection = currentUser.clients
        client = clientCollection.get(user.id)
        unless client
          client = new User(user, parse: true)
          clientCollection.add(client)
        client
      @clients = new Backbone.Collection(clients)