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
      newData = {}
      url = "#{@model.urlRoot}/?user[reset_password_token]=#{@token}"
      for key, value of data
        newKey = "user[#{key}]"
        url += "&#{newKey}=#{value}"
      $.ajax
        method: 'PUT'
        url: url
        dataType: 'json'
        statusCode:
          204: (data) =>
            App.request 'messenger:show',
              hideAfter: 5
              message: "Password was successfully changed"
              type: 'success'
            window.location.replace '#login'
          422: (data) =>
            App.request 'messenger:show',
              hideAfter: 5
              message: "Reset password token is invalid"
              type: 'error'
