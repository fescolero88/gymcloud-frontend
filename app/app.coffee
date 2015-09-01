define [
  'config'
  'backbone.marionette'
  'handlers/spinner'
  'handlers/ajax_setup'
  'handlers/user_authorization'
  'handlers/user_collections_preload'
  'handlers/data'

  'deps/scripts'
  'deps/fonts'
  'deps/styles_vendor'
  'deps/styles_app'
], (
  config
  Marionette
  spinnerHandler
  ajaxSetupHandler
  userAuthorizationHandler
  userCollectionsPreload
  dataHandler
) ->

  FormValidatorHelper = require 'views/helpers/form-validator-helper'
  JqueryHelper = require 'views/helpers/jquery-helper'
  MessengerHelper = require 'views/helpers/messenger-helper'

  BaseView = require 'views/general/base-view'

  HeaderModule = require 'features/header/module'
  AuthModule = require 'modules/auth/auth-module'
  ProfileModel = require 'models/auth/profile-model'

  MainTrainerModule = require 'modules/main-trainer/main-trainer-module'
  MainClientModule = require 'modules/main-client/main-client-module'
  LibraryPresetModule = require 'modules/general/library-preset-module'
  PrototypeModule = require 'modules/prototype/prototype-module'
  SearchModule = require 'features/search/module'

  ModalConfirmView = require 'views/general/modal-confirm-view'
  ModalAddToLibraryView = require 'views/general/modal_add_to_library_view'

  class Application extends Marionette.Application

    initialize: ->

      @addInitializer ->
        dataHandler(this)
        @data.profileModel = new ProfileModel

      @addInitializer ->
        spinnerHandler(this)
        userAuthorizationHandler(this)
        ajaxSetupHandler(this, config)

      @addInitializer ->
        if @request('accessToken:get')
          @data.profileModel.fetch().then =>
            userCollectionsPreload(@data.profileModel)
            @vent.trigger 'profile:ready'

      @on 'start', ->

        # --- Helpers -----
        new JqueryHelper().initialize()
        new FormValidatorHelper().initialize()
        new MessengerHelper().initialize()
        # --- Helpers -----

        @reqres.setHandler 'data:reload', (category, rootId) ->
          $.ajax
            url: "/api/mobile/library/#{rootId}"
            type: 'GET'
            dataType: 'json'
            success: (data) ->
              App.data[category] = data.items

        @reqres.setHandler 'base:confirmationalModal', (data) =>
          confirmView = new ModalConfirmView data
          region = @baseView.baseModalRegion
          region.show(confirmView)
          region.$el.modal('show')

          @listenToOnce confirmView, "modal:closed", =>
            region.$el.modal('hide')
            region.destroy()

        @reqres.setHandler 'base:addToLibraryModal', (data) =>
          addToLibraryView = new ModalAddToLibraryView data
          region = @baseView.baseModalRegion
          region.show(addToLibraryView)
          region.$el.modal('show')

          @listenToOnce addToLibraryView, "modal:closed", =>
            region.$el.modal('hide')
            region.destroy()

        @reqres.setHandler 'ajax:options:create', (params) ->
          options =
            url: params.url
            type: params.type || 'POST' # set default to post since this is commonly used for not restful requests
            contentType: params.contentType || 'application/json'
            data: params.data || {}

        # --- Data handlers -----

        # --- Base layout -----
        @baseView = new BaseView
        @reqres.setHandler 'app:views:base', =>
          @baseView
        @baseView.render()
        @appRegion = @baseView.appRegion
        # --- Base layout -----

        # --- Add modules -----
        @module 'Header', HeaderModule
        @module 'Auth', AuthModule
        @module 'MainTrainer', MainTrainerModule
        @module 'MainClient', MainClientModule
        @module 'LibraryPreset', LibraryPresetModule
        @module 'Prototype', PrototypeModule
        @module 'Search', SearchModule

        startHistory = -> Backbone.history.start() if Backbone.history
        if @request('accessToken:get') && @request('data:profile').isEmpty()
          App.vent.on('profile:ready', startHistory)
        else
          startHistory()
        # --- Add modules -----

  $ ->
    window.App = new Application
    window.App.start()
