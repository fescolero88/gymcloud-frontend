config = require 'config'
Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class AuthView extends Marionette.ItemView

  template: Templates.auth.auth

  events:
    'submit form': 'login'

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
    if @model.isValid true
      data =
        username: @model.get 'email'
        password: @model.get 'password'
        grant_type: 'password'
        client_id: config.oauthClientId

      $.ajax
        url: '/oauth/token'
        type: 'POST'
        dataType: 'json'
        data: JSON.stringify data
        success: (data) =>
          window.localStorage.setItem 'accessToken', data.access_token
          @getProfile()
        statusCode:
          401: (data) =>
            App.request 'messenger:show',
              hideAfter: 10
              message: "The email or password you entered is incorrect"
              type: 'error'

  getProfile: ->
    profileModel = App.request 'data:profile'
    profileModel.fetch().then =>
      accountType = profileModel.get('account_type')
      App.vent.trigger("module:main-#{accountType}:start")
      if accountType is 'trainer'
        window.location.replace '#/tr'
      else
        window.location.replace '#'
      App.vent.trigger 'profile:ready'
