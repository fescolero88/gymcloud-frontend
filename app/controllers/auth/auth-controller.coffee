Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

AuthLayoutView = require 'views/auth/auth_layout_view'
AuthView = require 'views/auth/auth-view'
ForgotPasswordView = require 'views/auth/forgot-password-view'
SignUpView = require 'views/auth/sign-up-view'
ResetPasswordView = require 'views/auth/reset-password-view'

ForgotPasswordModel = require 'models/auth/forgot-password-model'

module.exports = class AuthController extends Marionette.Controller

  initialize: (options) ->
    @region = options.region
    @layoutView = options.layoutView

  login: (signUp) =>
    @auth = new AuthView(signUp: signUp)
    if window.localStorage.accessToken
      window.location.replace '#'
    else
      @layoutView.mainRegion.show @auth

  logout: =>
    #App.vent.trigger 'module:auth:login'
    window.localStorage.removeItem 'accessToken'
    window.location.replace '#login'

  forgotPassword: ->
    @layoutView.mainRegion.show new ForgotPasswordView model: new ForgotPasswordModel

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
