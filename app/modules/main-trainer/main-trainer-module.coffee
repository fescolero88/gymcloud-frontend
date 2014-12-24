Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ClientsController = require '../../controllers/trainer/clients/clients-controller.coffee'
ClientsRouter = require '../../routers/trainer/clients/clients-router.coffee'

MessagesController = require '../../controllers/general/messages/messages-controller.coffee'
MessagesRouter = require '../../routers/general/messages/messages-router.coffee'

MainView = require '../../views/general/main-view.coffee'
SideBarView = require '../../views/trainer/sidebar-view.coffee'
HeaderView = require '../../views/general/header-view.coffee'
ModalView = require '../../views/general/modal-view.coffee'

module.exports = class MainTrainerModule extends Marionette.Module
  initialize: =>
    @on 'start', () ->
      if Backbone.history
        Backbone.history.stop()
        Backbone.history.start()

    @addInitializer (options) =>
      @main_view = new MainView()
      @sidebar_view = new SideBarView()
      @header_view = new HeaderView()
      @modal_view = new ModalView()

      @app.appRegion.show @main_view

      @main_view.header.show @header_view
      @main_view.menu.show @sidebar_view
      @main_view.modals.show @modal_view

    # Clients
    @addInitializer (options) =>
      @clients_controller = new ClientsController { main_view: @main_view }
      @clients_router = new ClientsRouter { controller: @clients_controller }

    # Messages
    @addInitializer (options) =>
      @messages_controller = new MessagesController { main_view: @main_view }
      @messages_router = new MessagesRouter { controller: @messages_controller }

    @on 'stop', () =>
      @app.appRegion.reset()
