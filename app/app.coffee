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

AuthModule = require 'modules/auth/auth-module'
ProfileModel = require 'models/auth/profile-model'

MainTrainerModule = require 'modules/main-trainer/main-trainer-module'
MainClientModule = require 'modules/main-client/main-client-module'


class App extends Marionette.Application
  initialize: ->
    new FormValidatorHelper().initialize()

    @on 'start', ->
      @loadingCount = 0
      $(document).ajaxStart () =>
        @vent.trigger "spinner:global:start"  if ++@loadingCount is 1

      $(document).ajaxComplete () =>
        if @loadingCount > 0
          @vent.trigger "spinner:global:stop"  if --@loadingCount is 0

    @addInitializer ->
      @historyStarted = false
      @vent.on "App:history:start", =>
        if Backbone.history and !@historyStarted
          Backbone.history.start()
          @historyStarted = true

    @addInitializer ->
      App.data = {}
      App.data.profileModel = new ProfileModel()

      @reqres.setHandler 'auth:isAuthorized', (permission)->
        accountType = App.data.profileModel.get('account_type')
        if window.localStorage.accessToken
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


    @addInitializer (options) =>
      new ViewHelper().initialize(Handlebars)
      @addRegions
        appRegion: 'region[data-name="app"]'

    @addInitializer ->
      spinner = new Spinner
      @vent.on "spinner:global:start", ->
        spinner.spin(document.getElementById('center-spin'))

      @vent.on "spinner:global:stop", ->
        spinner.stop()

      $(document).ajaxError (event, jqxhr, settings, thrownError)->
        if jqxhr.status in [401]
          window.location.replace '#/logout'
        spinner.stop()
        spinner.stop()

    @addInitializer ->
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

    @addInitializer ->
      @vent.on "module:main-trainer:start", =>
        mainTrainerModule = @module('MainTrainer')
        if mainTrainerModule._isInitialized?
          @vent.trigger 'controller:main-trainer:refresh'
        else
          mainTrainerModule.start()
          @vent.trigger "App:history:start"

      @vent.on "module:main-client:start", =>
        mainClientModule = @module('MainClient')
        if mainClientModule._isInitialized?
          @vent.trigger 'controller:main-client:refresh'
        else
          mainClientModule.start()
          @vent.trigger "App:history:start"


    @addInitializer ->
      @module 'Auth', AuthModule
      @module 'MainTrainer', MainTrainerModule
      @module 'MainClient', MainClientModule

      if window.localStorage.accessToken
        @vent.trigger 'spinner:global:start'
        profileModel = @request 'data:profile'
        profileModel.fetch().then =>
          accountType = profileModel.get('account_type')
          @vent.trigger 'spinner:global:stop'
          @vent.trigger "module:main-#{accountType}:start"
          if accountType is 'trainer'
            if window.location.hash.split('/')[0] != '#tr'
              window.location.replace('#tr')
          else
            if window.location.hash.split('/')[0] is '#tr'
              window.location.replace('#')
      else
        @module('Auth').start()
        @vent.trigger "App:history:start"

$ ->
  window.App = new App()
  window.App.start()

new JqueryHelper().initialize()
