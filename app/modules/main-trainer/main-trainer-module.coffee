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

  initialize: ->
    @on 'start', ->
      @trainerController = new TrainerController
      @trainerRouter = new TrainerRouter { controller: @trainerController }

    App.vent.on 'module:main-trainer:beforeAction', =>
      @refresh()

  refresh: ->
    if !@mainView? or @mainView.isDestroyed
      @mainView = new MainView()
      @app.appRegion.show @mainView
      @trainerController.mainView = @mainView
    if !@sidebarView? or @sidebarView.isDestroyed
      @sidebarView = new SideBarView()
      @mainView.menu.show @sidebarView
    if !@headerView? or @headerView.isDestroyed
      @headerView = new HeaderView()
      @mainView.header.show @headerView
