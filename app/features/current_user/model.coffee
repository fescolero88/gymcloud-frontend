define [
  'models/user_profile'
  'backbone-nested'
], (
  UserProfile
) ->

  class CurrentUserModel extends Backbone.NestedModel

    url: '/users/me'

    parse: (data) =>
      @.clear()
      @profile = new UserProfile(data.user_profile)
      data.user_profile = @profile.attributes
      data
