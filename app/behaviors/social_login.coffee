define [
], (
) ->

  class SocialLoginBehavior extends Marionette.Behavior

    ui:
      'fbButton': 'span.btn.btn-primary[data-social="fb"]'
      'gplusButton': 'span.btn.btn-danger[data-social="gplus"]'

    events:
      'click @ui.gplusButton': 'gplusLogin'
      'click @ui.fbButton': 'fbLogin'

    initialize: ->
      @gplusInit()
      @fbInit()

    fbInit: ->
      ((d, s, id) ->
        return if d.getElementById(id)
        js = d.createElement(s)
        js.id = id
        js.src = '//connect.facebook.net/en_US/sdk.js'
        fjs = d.getElementsByTagName(s)[0]
        fjs.parentNode.insertBefore js, fjs
      ) document, 'script', 'facebook-jssdk'
      window.fbAsyncInit = ->
        FB.init
          appId: '1664728030447432'
          cookie: true
          xfbml: true
          version: 'v2.2'

    fbLogin: (e) ->
      FB.login ((response) =>
        @getToken('facebook', response) if response.authResponse
      ), {
        auth_type: 'reauthenticate'
        scope: 'email,public_profile'
      }

    gplusInit: ->
      $.ajax
        url: 'https://apis.google.com/js/client:plus.js'
        dataType: 'script'
        cache: true
        beforeSend: -> # don't add our domain to url

    gplusLogin: (e) ->
      window.gapi?.auth.authorize {
        immediate: false
        response_type: 'code'
        cookie_policy: 'single_host_origin'
        client_id: '686822539338-h8pp1erjru867em1h45f7rf0qe0ftpdf.apps.googleusercontent.com'
        scope: 'email profile'
      }, (response) =>
        if response and !response.error
          @getToken('google_oauth2', response)
        else
          # google authentication failed
          console.log arguments

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