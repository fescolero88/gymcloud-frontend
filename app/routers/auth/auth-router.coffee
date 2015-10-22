CustomRouter  = require 'routers/general/custom-router'

module.exports = class AuthRouter extends CustomRouter

  appRoutes:
    'login(/)':                 'login'
    'logout(/)':                'logout'
    'forgot-password(/)':       'forgotPassword'
    'signup(/)':                'signUp'
    'reset/:token(/)':          'resetPassword'
    'confirm/:token(/)':        'confirmRegistration'
    'resend_confirmation(/)':   'resendConfirmation'

  before: (methodName) =>
    unless App.request 'accessToken:get'
      App.vent.trigger 'body:change-class', 'auth'
      App.vent.trigger 'module:auth:beforeAction'
