config = require 'config'
FormValidationBehaviour = require 'views/helpers/form-validation-behaviour'

module.exports = class ResetPasswordView extends Marionette.LayoutView

  template: require('templates/auth/reset_password')

  behaviors:
    FormValidationBehaviour:
      behaviorClass: FormValidationBehaviour

  ui:
    form: '.gc-reset-password-form'

  events:
    'submit @ui.form': 'submit'

  initialize: (data) =>
    @token = data.token
    Backbone.Validation.bind(this)

  submit: (ev) =>
    ev.preventDefault()
    data = _.extend @ui.form.serializeObject(),
      reset_password_token: @token
      id: 1 # model is not NEW now

    @model.save data,
      success: (model, data) ->
        App.request 'messenger:show',
          hideAfter: 5
          message: "Password was successfully changed"
          type: 'success'
        window.location.replace '#login'
      error: (model, xhr, error) =>
        errors = xhr.responseJSON.error
        for key, value of errors
          message = value.join(', ')
          input = @ui.form.find("input[name='#{key}']")
          uiGroup = input.parents('.form-group')
          @trigger 'switchError', message , uiGroup
        if errors.reset_password_token
          App.request 'messenger:show',
            hideAfter: 5
            message: "Reset password token is invalid"
            type: 'error'
