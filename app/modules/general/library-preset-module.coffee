Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

MainView = require 'views/general/main-view'
SideBarView = require 'views/client/clientpage-sidebar-view'
HeaderView = require 'views/general/header-view'

LibraryPresetController = require 'controllers/general/library-preset-controller'
LibraryPresetRouter = require 'routers/general/library-preset-router'
LibraryPresetModal = require 'views/general/modal-library-preset-view'

module.exports = class LibraryPresetModule extends Marionette.Module

  initialize: =>
    @on 'start', ->
      @presetController = new LibraryPresetController
      @router = new LibraryPresetRouter { controller: @presetController }

    App.vent.on 'module:library-preset:beforeAction', =>
      @refresh()


  refresh: ->
    if !@mainView? or @mainView.isDestroyed
      @mainView = new MainView()
      @app.appRegion.show @mainView
      @presetController.mainView = @mainView
    if !@sidebarView? or @sidebarView.isDestroyed
      @sidebarView = new SideBarView()
      @mainView.menu.show @sidebarView
    if !@headerView? or @headerView.isDestroyed
      @headerView = new HeaderView()
      @mainView.header.show @headerView

    @libraryPresetModal = new LibraryPresetModal
    @app.presetModalRegion.show @libraryPresetModal


