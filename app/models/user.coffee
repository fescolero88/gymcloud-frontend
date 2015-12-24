define [
  './concerns/nested_models'
  'models/user_profile'
  'backbone-nested'
], (
  NestedModelsConcern
  UserProfile
) ->

  class User extends Backbone.NestedModel

    type: 'User'

    urlRoot: '/users/'

    defaults:
      user_profile: {}

    constructor: ->
      @_nestedModelsInit
        user_profile: UserProfile
      super

    initialize: ->
      @_updateUserProfileAttrs()

    parse: (data) ->
      user_profile = data.user_profile
      @_nestedModelsParseAll(data)
      data.user_profile = user_profile
      data

    fullName: ->
      _.compact([
        @get('user_profile.first_name')
        @get('user_profile.last_name')
      ]).join(' ')

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

    getRootFolderFor: (type) ->
      name = _.titleize(type)
      if _.indexOf(['Exercises', 'Workouts', 'Programs'], name) == -1
        throw Error('No such folder')
      rootFolder = @library.first()
      rootFolder.items.findWhere(name: name)

    _updateUserProfileAttrs: ->
      @user_profile.set
        email: @get('email')
        live: @get('live')

  _.extend(User::, NestedModelsConcern)

  User
