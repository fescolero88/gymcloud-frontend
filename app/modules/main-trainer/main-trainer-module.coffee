Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ClientsController = require 'controllers/trainer/clients/clients-controller'
ClientsRouter = require 'routers/trainer/clients/clients-router'

MessagesController = require 'controllers/general/messages/messages-controller'
MessagesRouter = require 'routers/general/messages/messages-router'

MainView = require 'views/general/main-view'
SideBarView = require 'views/trainer/sidebar-view'
HeaderView = require 'views/general/header-view'
ModalView = require 'views/general/modal-view'

module.exports = class MainTrainerModule extends Marionette.Module
  initialize: =>
    @addInitializer (options) =>
      @mainView = new MainView()
      @sidebar_view = new SideBarView()
      @headerView = new HeaderView()
      @modalView = new ModalView()

      @app.appRegion.show @mainView

      @mainView.header.show @headerView
      @mainView.menu.show @sidebar_view
      @mainView.modals.show @modalView

    # Clients
    @addInitializer (options) ->
      @clients_controller = new ClientsController { mainView: @mainView }
      @clients_router = new ClientsRouter { controller: @clients_controller }

    # Messages
    @addInitializer (options) ->
      @messages_controller = new MessagesController { mainView: @mainView }
      @messages_router = new MessagesRouter { controller: @messages_controller }

    @on 'stop', ->
      @app.appRegion.reset()
