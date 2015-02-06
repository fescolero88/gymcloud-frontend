Marionette = require 'backbone.marionette'

AuthView = require 'views/auth/auth-view'
ForgotPasswordView = require 'views/auth/forgot-password-view'
SignUpView = require 'views/auth/sign-up-view'


module.exports = class AuthController extends Marionette.Controller

  initialize: (options) ->
    @region = options.region

  login: ->
    view = new AuthView
    if window.localStorage.accessToken
      window.location.replace '#'
    else
      @region.show(view)

  logout: ->
    #App.vent.trigger 'module:auth:login'
    window.localStorage.removeItem 'accessToken'
    window.location.replace '#login'

  forgotPassword: ->
    @region.show new ForgotPasswordView

  signUp: ->
    @region.show new SignUpView

