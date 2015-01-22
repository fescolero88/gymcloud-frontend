Marionette = require 'backbone.marionette'

AuthView = require 'views/auth/auth-view'


module.exports = class AuthController extends Marionette.Controller

  initialize: (options) ->
    @region = options.region

  login: ->
    if window.localStorage.accessToken
      window.location.replace '#'
    else
      view = new AuthView
      @region.show(view)

  logout: ->
    window.localStorage.removeItem 'accessToken'
    window.location.replace '#login'
