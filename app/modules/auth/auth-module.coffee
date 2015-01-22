Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

AuthController = require 'controllers/auth/auth-controller'
AuthRouter = require 'routers/auth/auth-router'


module.exports = class AuthModule extends Marionette.Module
  initialize: =>
    @addInitializer (options) ->
      @controller = new AuthController { region: @app.appRegion }
      @router = new AuthRouter { @controller }

    @on 'stop', ->
      @controller.destroy()
      @app.appRegion.reset()
