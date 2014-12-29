Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ClientPageController = require 'controllers/client/clientpage-controller'
ClientPageRouter = require 'routers/client/clientpage-router'

MessagesController = require 'controllers/general/messages/messages-controller'
MessagesRouter = require 'routers/general/messages/messages-router'

MainView = require 'views/general/main-view'
SideBarView = require 'views/client/clientpage-sidebar-view'
HeaderView = require 'views/general/header-view'

module.exports = class MainClientModule extends Marionette.Module
  initialize: =>
    @addInitializer (options) ->
      @mainView = new MainView()
      @headerView = new HeaderView()
      @sidebar_view = new SideBarView()

      @app.appRegion.show @mainView

      @mainView.header.show @headerView
      @mainView.menu.show @sidebar_view

    # Client's page
    @addInitializer (options) ->
      @clientpage_controller = new ClientPageController { mainView: @mainView }
      @clientpage_router = new ClientPageRouter { controller: @clientpage_controller }

    # Messages
    @addInitializer (options) ->
      @messages_controller = new MessagesController { mainView: @mainView }
      @messages_router = new MessagesRouter { controller: @messages_controller }


    @on 'stop', () ->
      @app.appRegion.reset()
