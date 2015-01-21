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

    @profileModel = new ProfileModel()

    @on 'start', ->
      @vent.trigger 'app:start-history'

      @loadingCount = 0
      $(document).ajaxStart () =>
        @vent.trigger "spinner:global:start"  if ++@loadingCount is 1

      $(document).ajaxComplete () =>
        if @loadingCount > 0
          @vent.trigger "spinner:global:stop"  if --@loadingCount is 0

    @addInitializer (options) =>
      @vent.on 'app:start-history', ->
        if Backbone.history
          Backbone.history.stop()
          Backbone.history.start()

    @addInitializer ->
      App.data = {}

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

      $(document).ajaxError ->
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
        @profileModel.fetch().then =>
          if @profileModel.get('account_type') is 'Client'
              @module 'Main', MainClientModule
            else
              @module 'Main', MainTrainerModule
            @vent.trigger 'app:start-history'
      else
        window.location.replace('#login')

    @addInitializer ->
      @vent.on 'modules:main:start', () =>
        @profileModel.fetch().then =>
          if @profileModel.get('account_type') is 'Client'
            @module 'Main', MainClientModule
          else
            @module 'Main', MainTrainerModule
          @module('Main').start()
          @vent.trigger 'app:start-history'
          window.location.replace('#clients')

      @vent.on "modules:auth:start", () =>
        @module('Main').stop()
        delete @Main
        window.location.replace('#login')


$ ->
  window.App = new App()
  window.App.start()

new JqueryHelper().initialize()
