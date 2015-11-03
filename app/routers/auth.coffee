define [
  'views/auth/auth-view'
  'views/auth/forgot-password-view'
  'views/auth/sign-up-view'
  'views/auth/reset-password-view'
  'views/auth/confirm-registration-view'
  'views/auth/resend-confirmation-view'

  'models/auth/confirm-registration-model'
  'models/auth/resend-confirmation-model'
  'models/auth/reset-password-model'
  'features/current_user/model'
], (
  AuthView
  ForgotPasswordView
  SignUpView
  ResetPasswordView
  ConfirmRegistrationView
  ResendConfirmationView

  ConfirmRegistrationModel
  ResendConfirmationModel
  ResetPasswordModel
  CurrentUser
) ->

  class Router extends Marionette.AppRouter

    appRoutes:
      'login': 'login'
      'logout':'logout'
      'signup': 'signUp'
      'forgot-password': 'forgotPassword'
      'resend_confirmation': 'resendConfirmation'
      'reset/:token': 'resetPassword'
      'confirm/:token': 'confirmRegistration'

  class Controller extends Marionette.Controller

    login: (signUp) =>
      if App.request('accessToken:get')
        App.vent.trigger('redirect:to', '#')
      else
        view = new AuthView
          signUp: signUp
        @_showView(view)

    logout: ->
      App.request('accessToken:remove')
      App.request('data:all:clear')
      App.request('current_user:reset')
      App.vent.trigger('redirect:to', '#login')

    forgotPassword: ->
      view = new ForgotPasswordView
      @_showView(view)

    signUp: =>
      unless App.request('accessToken:get')
        view = new SignUpView
        @_showView(view)
        @listenTo view, 'signup:complete', =>
          App.vent.trigger('redirect:to', '#login', trigger:false)
          @login(true)
      else
        App.vent.trigger('redirect:to', '#')

    resetPassword: (token) =>
      model = new ResetPasswordModel
      view = new ResetPasswordView
        model: model
        token: token
      @_showView(view)

    confirmRegistration: (token) =>
      view = new ConfirmRegistrationView
        token: token
        model: new ConfirmRegistrationModel
        profileModel: new CurrentUser
      @_showView(view)

    resendConfirmation: =>
      model = new ResendConfirmationModel
      view = new ResendConfirmationView
        model: model
      @_showView(view)

    _showView: (view) ->
      App.request 'views:show', view,
        layout: 'auth'
        region: 'content'

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
