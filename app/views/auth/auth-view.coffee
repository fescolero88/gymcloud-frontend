config = require 'config'
Marionette = require 'backbone.marionette'

module.exports = class AuthView extends Marionette.ItemView
  template: Templates.auth.auth

  events:
    "submit form": "login"

  ui:
    inputEmail: "input[type='email']"
    inputPassword: "input[type='password']"

  login: (event) ->
    event.preventDefault()
    data =
      username: @ui.inputEmail.val()
      password: @ui.inputPassword.val()
      grant_type: 'password'
      client_id: config.oauthClientId

    $.ajax
      url: '/oauth/token'
      type: 'POST'
      dataType: 'json'
      data: JSON.stringify data
      success: (data) =>
        window.localStorage.setItem 'accessToken', data.access_token
        @getProfile()

  getProfile: ->
    profileModel = App.request 'data:profile'
    profileModel.fetch().then =>
      if profileModel.get('account_type') is 'trainer'
        App.vent.trigger 'controller:main-trainer:refresh'
        window.location.replace '#/tr'
      else
        App.vent.trigger 'controller:main-client:refresh'
        window.location.replace '#'
