config = require 'config'
Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ForgotPasswordModel = require 'models/auth/forgot-password-model'

class ForgotPasswordFormView extends Marionette.ItemView
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
        statusCode:
          201: (data) =>
            @trigger 'next'

class ForgotPasswordSuccessView extends Marionette.ItemView
  template: Templates.auth.forgot_password_success

module.exports = class ForgotPasswordView extends Marionette.LayoutView
  template: Templates.auth.empty_layout

  regions:
    signUp: '#gc-default-region'

  initialize: =>
    @formView = new ForgotPasswordFormView model: new ForgotPasswordModel
    @successView = new ForgotPasswordSuccessView
    @listenTo @formView, 'next', @nextStep
    @listenTo @successView, 'final', @final

  onShow: =>
    @signUp.show @formView

  nextStep: =>
    @signUp.show @successView

  final: () =>
    true




