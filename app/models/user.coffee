define [
  'models/user_profile'
], (
  UserProfile
) ->

  class User extends Backbone.Model

    urlRoot: '/users/me'

    parse: (data) ->
      @profile = new UserProfile(data.user_profile)
      data.user_profile = @profile.attributes
      data