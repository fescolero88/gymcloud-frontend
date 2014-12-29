Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

AuthController = require 'controllers/auth/auth-controller'
AuthRouter = require 'routers/auth/auth-router'
AuthView = require 'views/auth/auth-view'

module.exports = class AuthModule extends Marionette.Module
  initialize: =>
    @addInitializer (options) ->
      @auth_view = AuthView
      @controller = new AuthController { region: @app.appRegion, @auth_view }
      @router = new AuthRouter { @controller }

    @on 'stop', ->
      @controller.destroy()
      @app.appRegion.reset()
