Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class AuthView extends Marionette.ItemView

  template: Templates.auth.auth

  events:
    'submit form': 'login'

  modelEvents:
    'model:login:success': 'onLoginSuccess'
    'model:login:fail': 'onLoginFail'

  ui:
    form: '.gc-login-form'
    signUpModal: '#gc-signup-message'

  initialize: (data) ->
    @signUp = data.signUp
    Backbone.Validation.bind @

  onShow: ->
    if @signUp
      @ui.signUpModal.modal 'show'

  login: (event) ->
    event.preventDefault()
    formData = @ui.form.serializeObject()
    @model.set formData
    @model.login()

  getProfile: ->
    profileModel = App.request 'data:profile'
    profileModel.fetch().then =>
      accountType = profileModel.get('account_type')
      # a workaround - treat a coach as a trainer, treat athlete as a client
      if accountType is 'coach'
        profileModel.set('account_type', 'trainer')
        accountType = 'trainer'
      else if accountType is 'athlete'
        profileModel.set('account_type', 'client')
        accountType = 'client'

      App.vent.trigger("module:main-#{accountType}:start")
      if accountType is 'trainer'
        window.location.replace '#/tr'
      else
        window.location.replace '#'
      App.vent.trigger 'profile:ready'

  onLoginSuccess: (data) ->
    window.localStorage.setItem 'accessToken', data.access_token
    @getProfile()

  onLoginFail: ->
    App.request 'messenger:show',
      hideAfter: 10
      message: "The email or password you entered is incorrect"
      type: 'error'
