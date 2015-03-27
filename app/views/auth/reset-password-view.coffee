config = require 'config'
Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class ResetPasswordView extends Marionette.LayoutView
  template: Templates.auth.reset_password

  ui:
    form: '.gc-reset-password-form'

  events:
    'submit @ui.form': 'submit'

  initialize: (data) =>
    @token = data.token
    Backbone.Validation.bind @

  submit: (ev) =>
    ev.preventDefault()
    @model.set @ui.form.serializeObject()
    @model.set 'user\[password\]', @model.get 'password'
    @model.set 'user\[password_confirmation\]', @model.get 'password_confirmation'
    @model.set 'user\[reset_password_token\]', @token
    if @model.isValid true
      $.ajax
        method: 'PUT'
        url: @model.url
        dataType: 'json'
        data: JSON.stringify @model.attributes
        statusCode:
          204: (data) =>
            window.location.replace '#login'
          422: (data) =>
            if data.errors
              App.request 'messenger:show',
                hideAfter: 5
                message: "Reset password token is invalid"
                type: 'error'
