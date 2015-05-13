CustomRouter  = require 'routers/general/custom-router'

module.exports = class AuthRouter extends CustomRouter

  appRoutes:
    '':                         'login'
    'login(/)':                 'login'
    'logout(/)':                'logout'
    'forgot-password(/)':       'forgotPassword'
    'signup(/)':                'signUp'
    'reset/:token(/)':          'resetPassword'
    'confirm/:token(/)':        'confirmRegistration'
    'resend_confirmation(/)':   'resendConfirmation'

  before: (methodName) =>
    App.vent.trigger 'body:change-class', 'auth'
    App.vent.trigger 'module:auth:beforeAction'
