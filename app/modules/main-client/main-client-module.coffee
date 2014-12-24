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
    @on 'start', ->
      if Backbone.history
        Backbone.history.stop()
        Backbone.history.start()

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
