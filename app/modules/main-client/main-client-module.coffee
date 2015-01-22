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
    App.vent.on 'controller:main-client:refresh', =>
      @refresh true

    @addInitializer (options) ->
      @refresh false

    # Client's page
    @addInitializer (options) ->
      @clientController = new ClientController { mainView: @mainView }
      @clientRouter = new ClientRouter { controller: @clientController }

    @on 'stop', () ->
      @app.appRegion.reset()

  refresh: (newView)->
    @mainView = new MainView()
    @headerView = new HeaderView()
    @sidebarView = new SideBarView()

    if newView
      @app.appRegion.show @mainView
      @mainView.header.show @headerView
      @mainView.menu.show @sidebarView

      @clientController.newMainView @mainView
