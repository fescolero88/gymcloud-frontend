Marionette = require 'backbone.marionette'

module.exports = class AuthView extends Marionette.ItemView
  events:
    "submit form": "login"

  ui:
    inputEmail: "input[type='email']"
    inputPassword: "input[type='password']"

  initialize: =>
    @template = require '../../templates/auth/auth'

  login: (event) ->
    event.preventDefault()
    App.vent.trigger('spinner:global:start')
    username = @ui.inputEmail.val()
    password = @ui.inputPassword.val()
    authorized = @onAuthorized
    @trigger 'authenticate', { username, password, authorized }

  onAuthorized: ->
    App.vent.trigger "spinner:global:stop"
    App.vent.trigger "modules:main:start"
