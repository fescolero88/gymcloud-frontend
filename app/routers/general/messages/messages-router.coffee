Marionette = require 'backbone.marionette'

module.exports = class MessagesRouter extends Marionette.AppRouter

  appRoutes:
    'messages(/)': 'messages'
