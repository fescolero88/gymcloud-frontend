define [
  'models/user_profile'
  'backbone-nested'
], (
  UserProfile
) ->

  class User extends Backbone.NestedModel

    urlRoot: ->
      currentUserId = App.request('current_user_id')
      if currentUserId == @id then '/users/me' else '/users'

    defaults:
      user_profile: {}

    parse: (data) ->
      @profile = new UserProfile(data.user_profile)
      data.user_profile = @profile.attributes
      data

    invite: (email) ->
      options =
        url: "/users/#{@id}/invite"
        type: 'POST'
        processData: false
        contentType: 'application/json'
      options.data = JSON.stringify(email: email) if email

      request = (@sync || Backbone.sync).call(@, null, @, options)
      request
        .then (response) =>
          @trigger 'invite:success', response
        .fail (xhr, textStatus, errorThrown) =>
          @trigger 'invite:fail', 'Something went wrong'
      request
