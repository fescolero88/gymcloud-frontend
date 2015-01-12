Marionette = require 'backbone.marionette'

module.exports = class AuthController extends Marionette.Controller

  initialize: (options) ->
    @view = options.authView
    @region = options.region

  login: ->
    view = new @view
    if window.localStorage.accessToken
      window.location.replace('#')
    else
      @region.show(view)

    @listenTo view, 'authenticate', (data) =>
      @authenticate data.username, data.password, data.authorized

    @listenTo view, 'getProfile', =>
      @getProfile()

  authenticate: (username, password, authorized ) ->
    data =
      username: username
      password: password
      grant_type: 'password'
      client_id: '3f4e4ee19f38ca1839a29e47c21c9cd541faeaf42760d81ff415b0bb84037306'

    $.ajax
      url: '/oauth/token'
      type: 'POST'
      dataType: 'json'
      data: JSON.stringify data
      success: (data) ->
        window.localStorage.setItem 'accessToken', data.access_token
        authorized()
