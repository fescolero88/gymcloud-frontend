Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

TrainerController = require 'controllers/trainer/trainer-controller'
TrainerRouter = require 'routers/trainer/trainer-router'

MessagesController = require 'controllers/general/messages/messages-controller'
MessagesRouter = require 'routers/general/messages/messages-router'

MainView = require 'views/general/main-view'
SideBarView = require 'views/trainer/sidebar-view'
HeaderView = require 'views/general/header-view'
ModalView = require 'views/general/modal-view'

module.exports = class MainTrainerModule extends Marionette.Module
  initialize: =>
    App.vent.on 'controller:main-trainer:refresh', =>
      @refresh(true)

    @addInitializer (options) =>
      @refresh(false)

    # Clients
    @addInitializer (options) ->
      @trainerController = new TrainerController { mainView: @mainView }
      @trainerRouter = new TrainerRouter { controller: @trainerController }

    # Messages
    @addInitializer (options) ->
      @messagesController = new MessagesController { mainView: @mainView }
      @messagesRouter = new MessagesRouter { controller: @messagesController }

    @on 'stop', ->
      @app.appRegion.reset()

  refresh: (newView)->
    @mainView = new MainView()
    @sidebarView = new SideBarView()
    @headerView = new HeaderView()


    if newView
      @app.appRegion.show @mainView
      @mainView.header.show @headerView
      @mainView.menu.show @sidebarView
      @trainerController.newMainView @mainView
