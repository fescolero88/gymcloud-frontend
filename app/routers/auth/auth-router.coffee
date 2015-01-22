Marionette = require 'backbone.marionette'

module.exports = class AuthRouter extends Marionette.AppRouter

  appRoutes:
    'login(/)': 'login'
    'logout(/)': 'logout'
