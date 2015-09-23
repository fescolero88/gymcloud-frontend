AuthLayoutView = require 'views/auth/auth_layout_view'
AuthView = require 'views/auth/auth-view'
ForgotPasswordView = require 'views/auth/forgot-password-view'
SignUpView = require 'views/auth/sign-up-view'
ResetPasswordView = require 'views/auth/reset-password-view'
ConfirmRegistrationView = require 'views/auth/confirm-registration-view'
ResendConfirmationView = require 'views/auth/resend-confirmation-view'

ConfirmRegistrationModel = require 'models/auth/confirm-registration-model'
ResendConfirmationModel = require 'models/auth/resend-confirmation-model'
ResetPasswordModel = require 'models/auth/reset-password-model'
CurrentUser = require 'features/current_user/model'

module.exports = class AuthController extends Marionette.Controller

  initialize: (options) ->
    @region = options.region
    @layoutView = options.layoutView

  login: (signUp) =>
    view = new AuthView
      signUp: signUp
    if App.request 'accessToken:get'
      window.location.replace '#'
    else
      @layoutView.mainRegion.show(view)

  logout: =>
    App.request 'accessToken:remove'
    App.request 'data:all:clear'
    App.request 'current_user:reset'
    window.location.replace '#login'

  forgotPassword: ->
    view = new ForgotPasswordView
    @layoutView.mainRegion.show(view)

  signUp: =>
    view = new SignUpView
    @layoutView.mainRegion.show(view)
    @listenTo view, 'signup:complete', =>
      Backbone.history.navigate('#login', { trigger:false, replace: true })
      @login(true)

  resetPassword: (token) =>
    model = new ResetPasswordModel
    view = new ResetPasswordView
      model: model
      token: token
    @layoutView.mainRegion.show(view)

  confirmRegistration: (token) =>
    confirmRegistrationModel = new ConfirmRegistrationModel
    profileModel = new CurrentUser
    view = new ConfirmRegistrationView
      token: token
      model: confirmRegistrationModel
      profileModel: profileModel
    @layoutView.mainRegion.show(view)

  resendConfirmation: =>
    model = new ResendConfirmationModel
    view = new ResendConfirmationView
      model: model
    @layoutView.mainRegion.show(view)
