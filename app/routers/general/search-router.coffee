Backbone = require 'backbone'
CustomRouter  = require 'routers/general/custom-router'

module.exports = class SearchRouter extends CustomRouter
  appRoutes:
    'search/:q(/:entityType)(/:searchScope)': 'search'

  initialize: (opts)->
    super opts
    App.vent.on 'search:cancel', @previous

  before: (methodName) =>
    App.request 'auth:isAuthorized'
    App.vent.trigger 'module:search:beforeAction'

  previous: ->
    info = App.request 'lastHash:get'
    hash = if info then info.hash else '#'
    Backbone.history.navigate hash, { trigger: true }

  onRoute: (name, path, opts)-> false #don't log history for SearchRouter actions
