config = require 'config'
Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ForgotPasswordModel = require 'models/auth/forgot-password-model'
FormValidationBehaviour = require 'views/helpers/form-validation-behaviour'

class ForgotPasswordFormView extends Marionette.ItemView

  template: require('templates/auth/forgot-password')

  behaviors:
    FormValidationBehaviour:
      behaviorClass: FormValidationBehaviour

  ui:
    form: '.gc-forgot-password-form'
    emailField: '.gc-forgot-password-email'

  events:
    'submit @ui.form': 'submitForm'

  initialize: =>
    Backbone.Validation.bind @

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
            @trigger 'switchError', data.error, $inputGroup
        statusCode:
          201: (data) =>
            @trigger 'next'

class ForgotPasswordSuccessView extends Marionette.ItemView

  template: require('templates/auth/forgot_password_success')

module.exports = class ForgotPasswordView extends Marionette.LayoutView

  template: require('templates/auth/empty_layout')

  regions:
    signUp: '#gc-default-region'

  initialize: ->
    @formView = new ForgotPasswordFormView model: new ForgotPasswordModel
    @successView = new ForgotPasswordSuccessView
    @listenTo @formView, 'next', @nextStep
    @listenTo @successView, 'final', @final

  onShow: ->
    @signUp.show @formView

  nextStep: ->
    @signUp.show @successView

  final: ->
    true
