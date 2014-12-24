Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

AuthController = require '../../controllers/auth/auth-controller.coffee'
AuthRouter = require '../../routers/auth/auth-router.coffee'
AuthView = require '../../views/auth/auth-view.coffee'

module.exports = class AuthModule extends Marionette.Module
  initialize: =>
    @on 'start', ->
      if Backbone.history
        Backbone.history.stop()
        Backbone.history.start()

    @addInitializer (options) ->
      @auth_view = AuthView
      @controller = new AuthController { region: @app.appRegion, @auth_view }
      @router = new AuthRouter { @controller }

    @on 'stop', ->
      @controller.destroy()
      @app.appRegion.reset()
