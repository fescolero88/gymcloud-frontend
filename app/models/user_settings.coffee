define ->

  class UserSettings extends Backbone.Model

    type: 'UserSettings'

    urlRoot: '/user_settings'

    defaults:
      id: undefined
      user_id: undefined
      user_account_type_id: undefined
      user_account_type_name: ''
      units_system: 'imperial'
      is_tutorial_finished: false
      is_presets_loaded: false
