define [
  'config'
], (
  config
) ->

  class SocialLoginBehavior extends Marionette.Behavior

    key: 'social_login'

    _vendorKey: 'trainer_id'

    _vendorName: 'gymcloud'

    events:
      'click @ui.button': 'login'

    login: (e) ->
      throw('Not Implemented')

    getToken: (provider, resp) ->
      data = JSON.stringify _.omit(resp, 'g-oauth-window')
      $.ajax
        type: 'POST'
        url: "/users/auth/#{provider}/callback"
        dataType: 'json'
        contentType: 'application/json'
        data: data
        xhrFields: withCredentials: true
        success: (json) ->
          App.request('auth:onSuccess', json)
        error: ->
          App.request('messenger:explain', 'login.failed')
      false

    getVendorAppId: ->
      vendor = config.vendor[@_vendorName]
      vendor?[@_vendorKey] || throw('Not Implemented')
