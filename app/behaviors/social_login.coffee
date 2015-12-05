define [
], (
) ->

  class SocialLoginBehavior extends Marionette.Behavior

    ui:
      'fbButton': 'span.btn.btn-primary[data-social="fb"]'
      'gplusButton': 'span.btn.btn-danger[data-social="gplus"]'

    events:
      'click @ui.gplusButton': 'gplusLogin'

    initialize: ->
      $.ajax
        url: 'https://apis.google.com/js/client:plus.js'
        dataType: 'script'
        cache: true
        beforeSend: ->

    gplusLogin: (e) =>
      window.gapi?.auth.authorize {
        immediate: false
        response_type: 'code'
        cookie_policy: 'single_host_origin'
        client_id: '686822539338-h8pp1erjru867em1h45f7rf0qe0ftpdf.apps.googleusercontent.com'
        scope: 'email profile'
      }, (response) =>
        if response and !response.error
          @getToken(response)
        else
          # google authentication failed
          console.log arguments
          
    getToken: (resp) ->
      $.ajax
        type: 'POST'
        url: '/users/auth/google_oauth2/callback'
        dataType: 'json'
        contentType: 'application/json'
        data: JSON.stringify(resp)
        success: (json) ->
          App.request('auth:onSuccess', json)