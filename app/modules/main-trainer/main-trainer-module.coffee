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
      @sidebarView = new SideBarView()
      @headerView = new HeaderView()
      @modalView = new ModalView()

      @app.appRegion.show @mainView

      @mainView.header.show @headerView
      @mainView.menu.show @sidebarView
      @mainView.modals.show @modalView

    # Clients
    @addInitializer (options) ->
      @clientsController = new ClientsController { mainView: @mainView }
      @clientsRouter = new ClientsRouter { controller: @clientsController }

    # Messages
    @addInitializer (options) ->
      @messagesController = new MessagesController { mainView: @mainView }
      @messagesRouter = new MessagesRouter { controller: @messagesController }

    @on 'stop', ->
      @app.appRegion.reset()
