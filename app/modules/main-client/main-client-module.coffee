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
      @sidebarView = new SideBarView()

      @app.appRegion.show @mainView

      @mainView.header.show @headerView
      @mainView.menu.show @sidebarView

    # Client's page
    @addInitializer (options) ->
      @clientpageController = new ClientPageController { mainView: @mainView }
      @clientpageRouter = new ClientPageRouter { controller: @clientpageController }

    # Messages
    @addInitializer (options) ->
      @messagesController = new MessagesController { mainView: @mainView }
      @messagesRouter = new MessagesRouter { controller: @messagesController }


    @on 'stop', () ->
      @app.appRegion.reset()
