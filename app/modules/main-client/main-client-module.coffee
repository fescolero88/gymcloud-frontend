Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ClientController = require 'controllers/client/clientpage-controller'
ClientRouter = require 'routers/client/client-router'

MessagesController = require 'controllers/general/messages/messages-controller'
MessagesRouter = require 'routers/general/messages/messages-router'

MainView = require 'views/general/main-view'
SideBarView = require 'views/client/clientpage-sidebar-view'
HeaderView = require 'views/general/header-view'

module.exports = class MainClientModule extends Marionette.Module

  initialize: =>
    @on 'start', ->
      @clientController = new ClientController
      @clientRouter = new ClientRouter { controller: @clientController }

    App.vent.on 'module:main-client:beforeAction', =>
      @refresh()

  refresh: ->
    if !@mainView? or @mainView.isDestroyed
      @mainView = new MainView()
      @app.appRegion.show @mainView
      @clientController.mainView = @mainView
    if !@sidebarView? or @sidebarView.isDestroyed
      @sidebarView = new SideBarView()
      @mainView.menu.show @sidebarView
    if !@headerView? or @headerView.isDestroyed
      @headerView = new HeaderView()
      @mainView.header.show @headerView
