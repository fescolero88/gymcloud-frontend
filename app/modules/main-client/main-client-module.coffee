ClientController = require 'controllers/client/clientpage-controller'
ClientRouter = require 'routers/client/client-router'

MessagesController = require 'controllers/general/messages/messages-controller'
MessagesRouter = require 'routers/general/messages/messages-router'

MainView = require 'views/general/main-view'
SideBarView = require 'features/sidebar/view'
ClientPageView = require 'views/client/clientpage-view'
ClientPageNavView = require 'views/client/clientpage-nav-view'

module.exports = class MainClientModule extends Marionette.Module

  initialize: =>
    @on 'start', ->
      @clientController = new ClientController
      @clientRouter = new ClientRouter
        controller: @clientController

  # not sure what this is for. leaving this here for future reference
  ###
  refresh: =>
    if !@userPageView or @userPageView.isDestroyed
      @userPageView = new ClientPageView()
      @mainView.content.show @userPageView
      @clientController.userPageView = @userPageView

      @navView = new ClientPageNavView()
      @userPageView.nav.show @navView
  ###
