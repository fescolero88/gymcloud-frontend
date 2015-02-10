window.Templates = require 'templates/templates_build.js'
config = require 'config'
require 'moment'

Spinner = require 'spinner'
Sortable = require 'jquery-sortable'
Handlebars = require 'handlebars'

Backbone = require 'backbone'
Backbone.Validation = require 'backbone.validation'
Backbone.$ = require 'jquery'
Marionette = require 'backbone.marionette'

require 'bootstrap'
require 'selectize'

ViewHelper = require 'views/helpers/view-helper'
FormValidatorHelper = require 'views/helpers/form-validator-helper'
JqueryHelper = require 'views/helpers/jquery-helper'

BaseView = require 'views/general/base-view'

AuthModule = require 'modules/auth/auth-module'
ProfileModel = require 'models/auth/profile-model'

MainTrainerModule = require 'modules/main-trainer/main-trainer-module'
MainClientModule = require 'modules/main-client/main-client-module'


class App extends Marionette.Application
  initialize: ->
    @on 'start', ->
      # --- Helpers -----
      new JqueryHelper().initialize()
      new ViewHelper().initialize(Handlebars)
      new FormValidatorHelper().initialize()
      # --- Helpers -----

      # --- Globar spinner -----
      spinner = new Spinner
      @vent.on "spinner:global:start", ->
        spinner.spin(document.getElementById('center-spin'))

      @vent.on "spinner:global:stop", ->
        spinner.stop()
      # --- Globar spinner -----

      # --- Ajax handlers -----
      @loadingCount = 0
      $(document).ajaxStart () =>
        @vent.trigger "spinner:global:start"  if ++@loadingCount is 1

      $(document).ajaxComplete () =>
        if @loadingCount > 0
          @vent.trigger "spinner:global:stop"  if --@loadingCount is 0

      $(document).ajaxError (event, jqxhr, settings, thrownError)->
        if jqxhr.status in [401] #403
          window.location.replace '#/logout'
        spinner.stop()

      $.ajaxSetup
        headers: {'X-Requested-With': 'XMLHttpRequest'}
        contentType: "application/json"

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

      @reqres.setHandler 'auth:isAuthorized', (permission)=>
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

      @reqres.setHandler 'data:exercises:reset', (data)->
        App.data.exercises = data

      @reqres.setHandler 'data:workouts', ->
        App.data.workouts

      @reqres.setHandler 'data:workouts:reset', (data)->
        App.data.workouts = data

      @reqres.setHandler 'data:programs', ->
        App.data.programs

      @reqres.setHandler 'data:programs:reset', (data)->
        App.data.programs = data
      # --- Data handlers -----

      # --- Base layout -----
      baseView = new BaseView()
      baseView.render()
      @appRegion = baseView.appRegion
      # --- Base layout -----

      # --- Add modules -----
      @module 'Auth', AuthModule
      @module 'MainTrainer', MainTrainerModule
      @module 'MainClient', MainClientModule

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
            if @checkPermission != accountType
              if accountType is 'trainer'
                window.location.replace '#tr'
              else
                window.location.replace '#'
          baseView.show()
      else
        baseView.show()
      # --- Get profile -----

$ ->
  window.App = new App()
  window.App.start()
