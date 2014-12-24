Spinner = require 'spinner'

Backbone = require 'backbone'
Backbone.$ = require 'jquery'
Marionette = require 'backbone.marionette'

Handlebars = require 'handlebars'
ViewHelper = require './views/helpers/view-helper.coffee'

AuthModule = require './modules/auth/auth-module.coffee'

MainTrainerModule = require './modules/main-trainer/main-trainer-module.coffee'
MainClientModule = require './modules/main-client/main-client-module.coffee'

class App extends Marionette.Application
  initialize: ->
    @profile_model = new Backbone.Model()

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
          options.url += "?access_token=#{window.localStorage.accessToken}"
        options


    @module 'Auth', AuthModule
    if window.localStorage.accessToken
      @profile_model.url = "//gymcloud-stagingapp.herokuapp.com/api/mobile/me?access_token=#{window.localStorage.accessToken}"
      @profile_model.fetch().then =>
        if @profile_model.get('account_type') is 'Client'
            @module 'Main', MainClientModule
          else
            @module 'Main', MainTrainerModule
    else
      window.location.replace('#login')

    @addInitializer ->
      @vent.on "modules:main:start", () =>
        @profile_model.url = "/api/mobile/me"
        @profile_model.fetch().then =>
          if @profile_model.get('account_type') is 'Client'
            @module 'Main', MainClientModule
          else
            @module 'Main', MainTrainerModule
          @module('Main').start()
          window.location.replace('#clients')

      @vent.on "modules:auth:start", () =>
        @module('Main').stop()
        delete @Main
        window.location.replace('#login')

    @start()


$ ->
  window.App = new App()
