define [
  'config'

  'handlers/ajax_setup'
  'handlers/data'
  'handlers/form_validator'
  'handlers/others'

  'views/general/base-view'
  'views/general/main-view'
  'features/sidebar/view'

  'features/current_user/module'
  'features/header/module'
  'features/spinner/module'
  'features/messenger/module'
  'features/sidebar/module'
  'modules/auth/auth-module'
  'modules/main-trainer/main-trainer-module'
  'modules/main-client/main-client-module'
  'modules/general/library-preset-module'
  'modules/prototype/prototype-module'
  'features/sortables/module'
  'features/search/module'

  'deps/scripts'
  'deps/fonts'
  'deps/styles_vendor'
  'deps/styles_app'
], (
  config

  ajaxSetupHandler
  dataHandler
  formValidatorHandler
  othersHandler

  BaseView
  MainView
  SidebarView

  CurrentUserModule
  HeaderModule
  SpinnerModule
  MessengerModule
  SidebarModule
  AuthModule
  MainTrainerModule
  MainClientModule
  LibraryPresetModule
  PrototypeModule
  SortableModule

  SearchModule
) ->

  class Application extends Marionette.Application

    request: (handler) ->
      if @reqres.hasHandler(handler)
        super
      else
        msg = "handler is not defined - #{handler}"
        throw(Error(msg))

    initialize: ->
      @on 'before:start', ->
        @_initPromises()
        @_initModules()
          .done(@promises.modules.resolve)
        @_initLayout()
          .done(@promises.layout.resolve)

      @on 'start', ->
        defer = new $.Deferred
        @request('current_user:init:user')
          .then( =>
            @request('current_user:init:collections')
              .always(@promises.collections.resolve)
          )
          .fail(@promises.collections.resolve)
          .always(@promises.user.resolve)

        dfds = _.values(@promises)
        $.when(dfds...).done =>
          @_initHistory()
          defer.resolve()

        defer.done =>
          @_isStarted = true
          @trigger('started')
          # send signal to render sidebar and header once everything is loaded
          @vent.trigger('app:view:main:render', @mainView)

        defer.promise()

      @addInitializer ->
        dataHandler(this)

      @addInitializer ->
        ajaxSetupHandler(this, config)
        formValidatorHandler()

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
      @module 'CurrentUser', CurrentUserModule
      @module 'Header', HeaderModule
      @module 'Sidebar', SidebarModule
      @module 'Spinner', SpinnerModule
      @module 'Messenger', MessengerModule
      @module 'Auth', AuthModule
      @module 'MainTrainer', MainTrainerModule
      @module 'MainClient', MainClientModule
      @module 'LibraryPreset', LibraryPresetModule
      @module 'Prototype', PrototypeModule
      @module 'Sortable', SortableModule
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
      @_initMainView()
      @appRegion = @baseView.appRegion
      defer.promise()

    _initMainView: ->
      @mainView = new MainView
      @baseView.getRegion('appRegion').show @mainView
      @baseView.currentView = @baseView
      @reqres.setHandler 'app:views:main', =>
        @mainView

    _initHistory: ->
      unless @request('current_user_id')
        window.location.hash = 'login'
      @_startHistory()

    _startHistory: -> Backbone.history?.start()

  $ ->
    window.App = new Application
    window.App.start()
