Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

AuthLayoutView = require 'views/auth/auth_layout_view'
AuthView = require 'views/auth/auth-view'
ForgotPasswordView = require 'views/auth/forgot-password-view'
SignUpView = require 'views/auth/sign-up-view'
ResetPasswordView = require 'views/auth/reset-password-view'

LoginModel = require 'models/auth/login-model'

module.exports = class AuthController extends Marionette.Controller

  initialize: (options) ->
    @region = options.region
    @layoutView = options.layoutView

  login: (signUp) =>
    @auth = new AuthView(signUp: signUp, model: new LoginModel)
    if window.localStorage.accessToken
      window.location.replace '#'
    else
      @layoutView.mainRegion.show @auth

  logout: =>
    window.localStorage.removeItem 'accessToken'
    window.location.replace '#login'

  forgotPassword: ->
    @layoutView.mainRegion.show new ForgotPasswordView

  signUp: =>
    @signUp = new SignUpView
    @layoutView.mainRegion.show @signUp
    @listenTo @signUp, 'signup:complete', =>
      href = '#login'
      Backbone.history.navigate(href, { trigger:false, replace: true })
      @login true

  resetPassword: =>
    @resetPassword = new ResetPasswordView
    @layoutView.mainRegion.show @resetPassword
