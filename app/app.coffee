define [
  'config'
  'backbone-validation'
  'backbone.marionette'
  'spinner'

  'deps/scripts'
  'deps/styles_vendor'
  'deps/styles_app'
], (
  config
  BackboneValidation
  Marionette
  Spinner
) ->

  Backbone.Validation = BackboneValidation
  Backbone.$ = $

  FormValidatorHelper = require 'views/helpers/form-validator-helper'
  JqueryHelper = require 'views/helpers/jquery-helper'

  BaseView = require 'views/general/base-view'

  AuthModule = require 'modules/auth/auth-module'
  ProfileModel = require 'models/auth/profile-model'

  MainTrainerModule = require 'modules/main-trainer/main-trainer-module'
  MainClientModule = require 'modules/main-client/main-client-module'
  LibraryPresetModule = require 'modules/general/library-preset-module'

  ModalConfirmView = require 'views/general/modal-confirm-view'
  ModalAddToLibraryView = require 'views/general/modal_add_to_library_view'

  class App extends Marionette.Application

    initialize: ->

      @on 'start', ->

        # --- Helpers -----
        new JqueryHelper().initialize()
        new FormValidatorHelper().initialize()
        # --- Helpers -----

        # --- Globar spinner -----
        spinner = new Spinner
        @vent.on 'spinner:global:start', ->
          spinner.spin(document.getElementById('center-spin'))

        @vent.on 'spinner:global:stop', ->
          spinner.stop()
        # --- Globar spinner -----

        # --- Ajax handlers -----
        @loadingCount = 0
        $(document).ajaxStart () =>
          @vent.trigger 'spinner:global:start'  if ++@loadingCount is 1

        $(document).ajaxComplete () =>
          if @loadingCount > 0
            @vent.trigger 'spinner:global:stop'  if --@loadingCount is 0

        $(document).ajaxError (event, jqxhr, settings, thrownError) =>
          if jqxhr.status is 401
            window.location.replace '#/logout'

          if jqxhr.status is 403
            if jqxhr.responseJSON.message?['generic']
              message = jqxhr.responseJSON.message['generic'].replace( /\s+(\[.+\])/, "")
              @request 'messenger:show',
                hideAfter: 5
                message: message
                type: 'error'
            else
              for name, error_msg of jqxhr.responseJSON.message
                @request 'messenger:show',
                  hideAfter: 5
                  message: "#{name}: #{error_msg[0]}"
                  type: 'error'
            spinner.stop()

        $.ajaxSetup
          headers: {'X-Requested-With': 'XMLHttpRequest'}
          contentType: 'application/json'

        $.ajaxPrefilter ( options, originalOptions, jqXHR ) =>
          options.url = config.api.url + options.url
          if window.localStorage.accessToken
            if options.url.indexOf('?') > 0
              options.url += "&access_token=#{window.localStorage.accessToken}"
            else
              options.url += "?access_token=#{window.localStorage.accessToken}"
          options
        # --- Ajax handlers -----

        # --- Data handlers -----
        App.data = {}
        App.data.profileModel = new ProfileModel()

        @reqres.setHandler 'auth:isAuthorized', (permission) =>
          if window.localStorage.accessToken
            if permission?
              accountType = App.data.profileModel.get('account_type')
              if accountType?
                if permission != accountType
                  if accountType is 'trainer'
                    window.location.replace '#tr'
                  else
                    window.location.replace '#'
                else
                  true
              else
                @checkPermission =  permission
            else
              true
          else
            window.location.replace '#login'
            false

        @reqres.setHandler 'data:profile', ->
          App.data.profileModel

        @reqres.setHandler 'data:exercises', ->
          App.data.exercises

        @reqres.setHandler 'data:exercises:root', ->
          App.data.exercisesRoot

        @reqres.setHandler 'data:exercises:reset', (data) ->
          App.data.exercises = data
          true

        @reqres.setHandler 'data:exercises:root:reset', (key) ->
          App.data.exercisesRoot = key

        @reqres.setHandler 'data:workouts', ->
          App.data.workouts

        @reqres.setHandler 'data:workouts:root', ->
          App.data.workoutsRoot

        @reqres.setHandler 'data:workouts:reset', (data) ->
          App.data.workouts = data
          true

        @reqres.setHandler 'data:workouts:root:reset', (key) ->
          App.data.workoutsRoot = key

        @reqres.setHandler 'data:programs', ->
          App.data.programs

        @reqres.setHandler 'data:programs:root', ->
          App.data.programsRoot

        @reqres.setHandler 'data:programs:reset', (data) ->
          App.data.programs = data
          true

        @reqres.setHandler 'data:programs:root:reset', (key) ->
          App.data.programsRoot = key

        @reqres.setHandler 'data:reload', (category, rootId) ->
          $.ajax
            url: "/api/mobile/library/#{rootId}"
            type: 'GET'
            dataType: 'json'
            success: (data) =>
              App.data[category] = data.items

        @reqres.setHandler 'data:delete', (category, key) ->
          items = App.data[category]
          deleteFromTree = (items, key) =>
            for item, index in items
              if item.isFolder
                deleteFromTree item.items, key
              else if item.key is key
                items.splice index, 1
                return
          deleteFromTree items, key

        @reqres.setHandler 'client:properties', (id) ->
          App.cache?['client:properties']?[id]

        @reqres.setHandler 'client:properties:set', (id, properties) ->
          App.cache ?= {}
          App.cache['client:properties'] ?= {}
          App.cache['client:properties'][id] = properties

        @reqres.setHandler 'my:properties', () =>
          profile = @request 'data:profile'
          App.cache?['client:properties']?[profile.get('id')]

        @reqres.setHandler 'my:properties:set', (properties) =>
          profile = @request 'data:profile'
          App.cache ?= {}
          App.cache['client:properties'] ?= {}
          App.cache['client:properties'][profile.get('id')] = properties

        @reqres.setHandler 'base:confirmationalModal', (data) =>
          confirmView = new ModalConfirmView data
          region = @baseView.baseModalRegion
          region.show(confirmView)

          @listenToOnce confirmView, "modal:closed", =>
            region.destroy()


        @reqres.setHandler 'base:addToLibraryModal', (data) =>
          addToLibraryView = new ModalAddToLibraryView data
          region = @baseView.baseModalRegion
          region.show(addToLibraryView)
          region.$el.modal('show')

          @listenToOnce addToLibraryView, "modal:closed", =>
            region.$el.modal('hide')
            region.destroy()

        @reqres.setHandler 'lastHash:get', ->
          App.data.lastHash

        @reqres.setHandler 'lastHash:set', (params) ->
          App.data.lastHash =
            hash: params.hash
            action: params.name

        # --- Data handlers -----
        
        # --- Base layout -----
        @baseView = new BaseView()
        @baseView.render()
        @appRegion = @baseView.appRegion
        # --- Base layout -----

        # --- Add modules -----
        @module 'Auth', AuthModule
        @module 'MainTrainer', MainTrainerModule
        @module 'MainClient', MainClientModule
        @module 'LibraryPreset', LibraryPresetModule

        if Backbone.history
          Backbone.history.start()
        # --- Add modules -----

        # --- Get profile -----
        if window.localStorage.accessToken
          profileModel = @request 'data:profile'
          profileModel.fetch().then =>
            @vent.trigger 'profile:ready'
            accountType = profileModel.get 'account_type'
            if @checkPermission?
              # a workaround - treat a coach as a trainer, treat athlete as a client
              if accountType is 'coach'
                profileModel.set('account_type', 'trainer')
                accountType = 'trainer'
              else if accountType is 'athlete'
                profileModel.set('account_type', 'client')
                accountType = 'client'

              if @checkPermission != accountType
                if accountType is 'trainer'
                  window.location.replace '#tr'
                else
                  window.location.replace '#'
            @baseView.trigger('showBody')
        else
          @baseView.trigger('showBody')
        # --- Get profile -----

  $ ->
    window.App = new App()
    window.App.start()
