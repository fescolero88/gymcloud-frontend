define [
  'config'

  'handlers/jquery'
  'handlers/spinner'
  'handlers/ajax_setup'
  'handlers/user_authorization'
  'handlers/user_collections_preload'
  'handlers/data'
  'handlers/form_validator'
  'handlers/others'

  'models/auth/profile-model'
  'views/general/base-view'
  'views/helpers/messenger-helper'

  'features/header/module'
  'modules/auth/auth-module'
  'modules/main-trainer/main-trainer-module'
  'modules/main-client/main-client-module'
  'modules/general/library-preset-module'
  'modules/prototype/prototype-module'
  'features/search/module'

  'deps/scripts'
  'deps/fonts'
  'deps/styles_vendor'
  'deps/styles_app'
], (
  config

  jqueryHandler
  spinnerHandler
  ajaxSetupHandler
  userAuthorizationHandler
  userCollectionsPreload
  dataHandler
  formValidatorHandler
  othersHandler

  CurrentUser
  BaseView
  MessengerHelper

  HeaderModule
  AuthModule
  MainTrainerModule
  MainClientModule
  LibraryPresetModule
  PrototypeModule
  SearchModule

) ->

  class Application extends Marionette.Application

    initialize: ->

      @on 'start', ->
        defer = new $.Deferred
        @_initPromises()
        @_initModules()
          .done(@promises.modules.resolve)
        @_initLayout()
          .done(@promises.layout.resolve)
        @_initUser()
          .then( =>
            @_initCollections()
              .always(@promises.collections.resolve)
              # @vent.trigger('profile:ready')
          )
          .fail(@promises.collections.resolve)
          .always(@promises.user.resolve)

        dfds = _.values(@promises)
        $.when(dfds...).done =>
          @_initHistory()
          defer.resolve()

        defer.promise()

      @addInitializer ->
        dataHandler(this)
        @data.current_user = new CurrentUser

      @addInitializer ->
        jqueryHandler()
        spinnerHandler(this)
        userAuthorizationHandler(this)
        ajaxSetupHandler(this, config)
        formValidatorHandler()

      @addInitializer ->
        new MessengerHelper().initialize()

      @addInitializer ->
        othersHandler(this)

    _initPromises: ->
      names = [
        'modules'
        'layout'
        'user'
        'collections'
      ]
      @promises = _.reduce names, (memo, name) ->
        memo[name] = new $.Deferred
        memo
      , {}

    _initModules: ->
      defer = new $.Deferred
      @module 'Header', HeaderModule
      @module 'Auth', AuthModule
      @module 'MainTrainer', MainTrainerModule
      @module 'MainClient', MainClientModule
      @module 'LibraryPreset', LibraryPresetModule
      @module 'Prototype', PrototypeModule
      @module 'Search', SearchModule
      defer.resolve()
      defer.promise()

    _initLayout: ->
      defer = new $.Deferred
      @baseView = new BaseView
      @reqres.setHandler 'app:views:base', =>
        @baseView
      @baseView.once('render', defer.resolve)
      @baseView.render()
      @appRegion = @baseView.appRegion
      defer.promise()

    _initUser: ->
      defer = new $.Deferred
      if @request('accessToken:get')
        @request('current_user').fetch()
          .success(defer.resolve)
          .fail(defer.reject)
      else
        defer.reject()
      defer.fail =>
        @request('accessToken:remove')
      defer.promise()

    _initCollections: ->
      defer = new $.Deferred
      dfds = userCollectionsPreload(App.request('current_user'))
      $.when(dfds...).then(defer.resolve)
      defer.promise()

    _initHistory: ->
      unless @request('current_user_id')
        window.location.hash = 'login'
      @_startHistory()

    _startHistory: -> Backbone.history?.start()

  $ ->
    window.App = new Application
    window.App.start()
