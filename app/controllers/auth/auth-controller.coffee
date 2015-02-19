Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

AuthView = require 'views/auth/auth-view'
ForgotPasswordView = require 'views/auth/forgot-password-view'
SignUpView = require 'views/auth/sign-up-view'

ForgotPasswordModel = require 'models/auth/forgot-password-model'

module.exports = class AuthController extends Marionette.Controller

  initialize: (options) ->
    @region = options.region

  login: (signUp)->
    @auth = new AuthView(signUp: signUp)
    if window.localStorage.accessToken
      window.location.replace '#'
    else
      @region.show @auth

  logout: ->
    #App.vent.trigger 'module:auth:login'
    window.localStorage.removeItem 'accessToken'
    window.location.replace '#login'

  forgotPassword: ->
    @region.show new ForgotPasswordView model: new ForgotPasswordModel

  signUp: ->
    @signUp = new SignUpView
    @region.show @signUp
    @listenTo @signUp, 'signup:complete', =>
      href = '#login'
      Backbone.history.navigate(href, { trigger:false, replace: true })
      @login true

