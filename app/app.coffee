window.Templates = require 'templates/templates_build.js'
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
      @vent.on "App:modules:load", (order)=>
        @module 'MainClient', MainClientModule
        @module 'MainTrainer', MainTrainerModule
        @vent.trigger "controller:main-#{order}:refresh"
        if Backbone.history
          Backbone.history.start()

    @addInitializer ->
      @vent.on "App:check-auth", (permission)=>
        if !window.localStorage.accessToken
          window.location.replace '#login'
        else
          profileModel = @request 'data:profile'
          accountType = profileModel.get 'account_type'

    @addInitializer ->
      App.data = {}
      App.data.profileModel = new ProfileModel()

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

    @addInitializer ->
      $.ajaxSetup
        headers: {'X-Requested-With': 'XMLHttpRequest'}
        contentType: "application/json"

      $.ajaxPrefilter ( options, originalOptions, jqXHR ) =>
        options.url = "//gymcloud-stagingapp.herokuapp.com" + options.url
        if window.localStorage.accessToken
          if options.url.indexOf('?') > 0
            options.url += "&access_token=#{window.localStorage.accessToken}"
          else
            options.url += "?access_token=#{window.localStorage.accessToken}"
        options


    @addInitializer ->
      @module 'Auth', AuthModule
      if window.localStorage.accessToken
        @vent.trigger 'spinner:global:start'
        profileModel = @request 'data:profile'
        profileModel.fetch().then =>
          if profileModel.get('account_type') is 'trainer'
            @vent.trigger 'App:modules:load', 'trainer'
          else
            @vent.trigger 'App:modules:load', 'client'
          @vent.trigger 'spinner:global:stop'
      else
        @vent.trigger 'App:modules:load'

$ ->
  window.App = new App()
  window.App.start()

new JqueryHelper().initialize()
