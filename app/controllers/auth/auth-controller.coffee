Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

AuthLayoutView = require 'views/auth/auth_layout_view'
AuthView = require 'views/auth/auth-view'
ForgotPasswordView = require 'views/auth/forgot-password-view'
SignUpView = require 'views/auth/sign-up-view'
ResetPasswordView = require 'views/auth/reset-password-view'
ConfirmRegistrationView = require 'views/auth/confirm-registration-view'

ConfirmRegistrationModel = require 'models/auth/confirm-registration-model'
LoginModel = require 'models/auth/login-model'
ResetPasswordModel = require 'models/auth/reset-password-model'

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

  resetPassword: (token) =>
    @resetPassword = new ResetPasswordView model: new ResetPasswordModel, token: token
    @layoutView.mainRegion.show @resetPassword

  confirmRegistration: (token) =>
    #@confirmPassword = new ConfirmPasswordView
    console.log 'test', token
    confirmRegistrationModel = new ConfirmRegistrationModel
    @confirmRegistrationView = new ConfirmRegistrationView token: token, model: confirmRegistrationModel
    @layoutView.mainRegion.show @confirmRegistrationView
