Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class ResendConfirmationView extends Marionette.ItemView

  template: Templates.auth.resend_confirmation

  initialize: ->
    @listenTo @model, 'model:auth_resend:success', @onResendSuccess
    @listenTo @model, 'model:auth_resend:fail', @onResendFailed

  onRender: ->

  ui:
    resendButton: 'button.resend-confirmation'
    emailInput: 'input[name=email]'
    resendFormControls: '.gc-resend-form-controls'
    resendSuccess: '.gc-resend-success'

  events:
    'click @ui.resendButton': 'resendInstructions'

  resendInstructions: ->
    console.log 'clicked'
    @model.set 'email', @ui.emailInput.val()
    ###
    isValid = @model.isValid('email')
    console.log isValid
    ###
    @model.resendConfirmation()

  onResendSuccess: ->
    @ui.resendFormControls.addClass 'hidden'
    @ui.resendSuccess.removeClass 'hidden'

  onResendFailed: ->
    alert 'failed'
