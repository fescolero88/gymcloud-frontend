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
    data = @ui.form.serializeObject()
    @model.set data
    if @model.isValid true
      for key, value of data
        data["user[#{key}]"] = value
        delete data[key]
      data["user[reset_password_token]"] = @token
      $.ajax
        method: 'PUT'
        url: @model.url
        dataType: 'json'
        data: JSON.stringify data
        statusCode:
          204: (data) =>
            window.location.replace '#login'
          422: (data) =>
            if data.errors
              App.request 'messenger:show',
                hideAfter: 5
                message: "Reset password token is invalid"
                type: 'error'
