define [
  'config'
], (
  config
) ->

  class SocialLoginBehavior extends Marionette.Behavior

    _vendorKey: 'trainer_id'

    _vendorName: 'gymcloud'

    events:
      'click @ui.button': 'login'

    login: (e) ->
      throw('Not Implemented')

    getToken: (provider, resp) ->
      $.ajax
        type: 'POST'
        url: "/users/auth/#{provider}/callback"
        dataType: 'json'
        contentType: 'application/json'
        data: JSON.stringify(resp)
        xhrFields: withCredentials: true
        success: (json) ->
          App.request('auth:onSuccess', json)

    getVendorAppId: ->
      vendor = config.vendor[@_vendorName]
      vendor?[@_vendorKey] || throw('Not Implemented')