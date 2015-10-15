LoginModel = require 'models/auth/login-model'

module.exports = class AuthView extends Marionette.ItemView

  template: require('templates/auth/auth')

  events:
    'submit form': 'login'

  ui:
    form: '.gc-login-form'
    signUpModal: '#gc-signup-message'

  behaviors:

    stickit:
      bindings:
        'input[name="username"]': 'username'
        'input[name="password"]': 'password'

  initialize: (data) ->
    @model = new LoginModel
    @listenTo(@model, 'model:login:success', @_onLoginSuccess)
    @listenTo(@model, 'model:login:fail', @_onLoginFail)
    @signUp = data.signUp
    Backbone.Validation.bind(this)

  onShow: ->
    if @signUp
      @ui.signUpModal.modal 'show'

  login: (event) ->
    @model.login()

  _onLoginSuccess: (data) ->
    App.request('auth:onSuccess', data)

  _onLoginFail: ->
    App.request 'messenger:show',
      hideAfter: 10
      message: "The email or password you entered is incorrect"
      type: 'error'
