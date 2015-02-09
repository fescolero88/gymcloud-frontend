CustomRouter  = require 'routers/general/custom-router'

module.exports = class AuthRouter extends CustomRouter

  appRoutes:
    'login(/)': 'login'
    'logout(/)': 'logout'
    'forgot-password(/)': 'forgotPassword'
    'signup(/)': 'signUp'

  before: (methodName)=>
    App.vent.trigger 'body:change-class', 'auth'

