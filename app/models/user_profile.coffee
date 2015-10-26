define [
  './concerns/avatar_background_color'
], (
  AvatarBackgroundColor
)->

  class UserProfile extends Backbone.Model

    urlRoot: '/user_profiles'

    defaults:
      avatar_background_color: ''
      avatar:
        url: ''
        large: url: ''
        thumb: url: ''

    validation:

      first_name:
        required: true

      last_name:
        required: true

      weight:
        required: false
        isFloat: true

      height:
        required: false
        isFloat: true

      bodyfat:
        required: false
        isFloat: true

      address:
        required: false

      zip:
        required: false
        pattern: 'digits'

      works_at:
        required: false

    initialize: ->
      super
      @_initBgColor()

  _.extend(UserProfile::, AvatarBackgroundColor)
  UserProfile