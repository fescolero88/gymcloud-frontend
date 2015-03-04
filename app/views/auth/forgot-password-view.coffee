config = require 'config'
Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class ForgotPasswordView extends Marionette.ItemView

  template: Templates.auth.forgot_password

  ui:
    form: '.gc-forgot-password-form'
    emailField: '.gc-forgot-password-email'

  events:
    'submit @ui.form': 'submitForm'

  initialize: =>
    Backbone.Validation.bind @

  switchError: (error_msg, $inputGroup) =>
    if error_msg
      $inputGroup.removeClass('gc-valid').addClass('gc-invalid')
      $inputGroup.find('.gc-valid-icon').addClass('hide')
      $inputGroup.find('.gc-error-message').text(error_msg)
    else
      $inputGroup.removeClass('gc-invalid').addClass('gc-valid')
      $inputGroup.find('.gc-valid-icon').removeClass('hide')
      $inputGroup.find('.gc-error-message').text('')

  submitForm: (ev) =>
    ev.preventDefault()
    formData = @ui.form.serializeObject()
    @model.set formData
    if @model.isValid true
      @model.save null,
        success: (model, data) =>
          if data.errors
            $input = @ui.emailField
            $inputGroup = $input.closest('.form-group')
            @switchError data.errors, $inputGroup
