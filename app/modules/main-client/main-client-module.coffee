Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ClientController = require 'controllers/client/clientpage-controller'
ClientRouter = require 'routers/client/client-router'

MessagesController = require 'controllers/general/messages/messages-controller'
MessagesRouter = require 'routers/general/messages/messages-router'

MainView = require 'views/general/main-view'
SideBarView = require 'views/client/sidebar-view'
# TODO: DELETE
SideBarView = require 'views/sidebar/sidebar_view'
ClientPageView = require 'views/client/clientpage-view'
ClientPageNavView = require 'views/client/clientpage-nav-view'

module.exports = class MainClientModule extends Marionette.Module

  initialize: =>
    @on 'start', ->
      @clientController = new ClientController
      @clientRouter = new ClientRouter
        controller: @clientController

    App.vent.on 'module:main-client:beforeAction', =>
      @refresh()

  refresh: ->
    if !@mainView? or @mainView.isDestroyed
      @mainView = new MainView()
      @app.appRegion.show @mainView
      @clientController.mainView = @mainView
      App.vent.trigger('app:view:main:render', @mainView)

    if !@sidebarView? or @sidebarView.isDestroyed
      @sidebarView = new SideBarView()
      @mainView.menu.show @sidebarView

    if !@userPageView or @userPageView.isDestroyed
      @userPageView = new ClientPageView()
      @mainView.content.show @userPageView
      @clientController.userPageView = @userPageView

      @navView = new ClientPageNavView()
      @userPageView.nav.show @navView
