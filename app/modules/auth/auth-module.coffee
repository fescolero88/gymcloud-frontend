AuthController = require 'controllers/auth/auth-controller'
AuthRouter = require 'routers/auth/auth-router'

AuthLayoutView = require 'views/auth/auth_layout_view'

module.exports = class AuthModule extends Marionette.Module

  initialize: =>
    @addInitializer (options) ->
      @controller = new AuthController { region: @app.appRegion }
      @router = new AuthRouter { @controller }

    @on 'stop', ->
      @controller.destroy()
      @app.appRegion.reset()

    App.vent.on 'module:auth:beforeAction', =>
      @refresh()

  refresh: ->
    if !@layoutView? or @layoutView.isDestroyed
      @layoutView = new AuthLayoutView()
      @app.appRegion.show @layoutView
      @controller.layoutView = @layoutView
