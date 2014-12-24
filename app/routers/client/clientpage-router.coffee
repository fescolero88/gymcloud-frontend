Marionette = require 'backbone.marionette'

module.exports = class ClientPageRouter extends Marionette.AppRouter

  appRoutes:
    'user/id/:id(/)': 'clientPageExercises'
