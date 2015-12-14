define [
  'models/user_profile'
  'backbone-nested'
], (
  UserProfile
) ->

  class CurrentUserModel extends Backbone.NestedModel

    url: '/users/me'

    parse: (data) =>
      @clear()
      @profile = new UserProfile(data.user_profile)
      data.user_profile = @profile.attributes
      data

    getRootFolderFor: (type) ->
      name = _.titleize(type)
      if _.indexOf(['Exercises', 'Workouts', 'Programs'], name) == -1
        throw Error('No such folder')
      rootFolder = @library.first()
      rootFolder.items.findWhere(name: name)
