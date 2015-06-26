config = require 'config'
Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class ResetPasswordView extends Marionette.LayoutView

  template: require('templates/auth/reset_password')

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
      ###
      url = "#{@model.urlRoot}?user[reset_password_token]=#{@token}"
      for key, value of data
        newKey = "user[#{key}]"
        url += "&#{newKey}=#{value}"
      ###
      data =
        user:
          reset_password_token: @token
          password: @model.get 'password'
          password_confirmation: @model.get 'password_confirmation'

      $.ajax
        method: 'PUT'
        url: @model.urlRoot
        dataType: 'json'
        contentType: 'application/json'
        data: JSON.stringify data
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
      .fail (xhr, textStatus, errorThrown) =>
        unless errorThrown
          App.request 'messenger:show',
            hideAfter: 5
            message: "Password was successfully changed"
            type: 'success'
          window.location.replace '#login'
