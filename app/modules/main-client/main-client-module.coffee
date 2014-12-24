Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ClientPageController = require '../../controllers/client/clientpage-controller.coffee'
ClientPageRouter = require '../../routers/client/clientpage-router.coffee'

MessagesController = require '../../controllers/general/messages/messages-controller.coffee'
MessagesRouter = require '../../routers/general/messages/messages-router.coffee'

MainView = require '../../views/general/main-view.coffee'
SideBarView = require '../../views/client/clientpage-sidebar-view.coffee'
HeaderView = require '../../views/general/header-view.coffee'

module.exports = class MainClientModule extends Marionette.Module
  initialize: =>
    @on 'start', () ->
      if Backbone.history
        Backbone.history.stop()
        Backbone.history.start()

    @addInitializer (options) =>
      @main_view = new MainView()
      @header_view = new HeaderView()
      @sidebar_view = new SideBarView()

      @app.appRegion.show @main_view

      @main_view.header.show @header_view
      @main_view.menu.show @sidebar_view

    # Client's page
    @addInitializer (options) =>
      @clientpage_controller = new ClientPageController { main_view: @main_view }
      @clientpage_router = new ClientPageRouter { controller: @clientpage_controller }

    # Messages
    @addInitializer (options) =>
      @messages_controller = new MessagesController { main_view: @main_view }
      @messages_router = new MessagesRouter { controller: @messages_controller }


    @on 'stop', () =>
      @app.appRegion.reset()
