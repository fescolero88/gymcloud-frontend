define [
  'query-string'

  'views/auth/auth-view'
  'views/auth/forgot-password-view'
  'features/signup/view'
  'views/auth/reset-password-view'
  'views/auth/confirm-registration-view'
  'views/auth/resend-confirmation-view'

  'models/auth/confirm-registration-model'
  'models/auth/resend-confirmation-model'
  'models/auth/reset-password-model'
  'features/signup/model'
  'features/current_user/model'
], (
  QueryString

  AuthView
  ForgotPasswordView
  SignUpView
  ResetPasswordView
  ConfirmRegistrationView
  ResendConfirmationView

  ConfirmRegistrationModel
  ResendConfirmationModel
  ResetPasswordModel
  AccountModel
  CurrentUser
) ->

  class Router extends Marionette.AppRouter

    appRoutes:
      'login': 'login'
      'logout':'logout'
      'signup': 'signUp'
      'signup?*queryString': 'signUp'
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

    signUp: (queryString) =>
      unless App.request('accessToken:get')
        queryParams = QueryString.parse queryString
        if queryParams.invitation_token
          client = queryParams

        view = new SignUpView
          model: new AccountModel
          client: client
        @_showView(view)

        @listenTo view, 'signup:complete', ->
          App.request('current_user').fetch().then ->
            App.request('current_user:init:collections').then ->
              App.vent.trigger('redirect:to', '#')
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
