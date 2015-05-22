Marionette = require 'backbone.marionette'
CustomRouter = require 'routers/general/custom-router'

module.exports = class LibraryPresetRouter extends CustomRouter

  appRoutes: 
    'library-preset(/)': 'loadPreset'

  before: (methodName) =>
    App.request 'auth:isAuthorized', 'client'
    App.vent.trigger 'module:library-preset:beforeAction'
