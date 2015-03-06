config = require 'config'
Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ResetPasswordModel = require 'models/auth/reset-password-model'

class ResetFormView extends Marionette.ItemView

  template: Templates.auth.reset_password

  ui:
    form: '.gc-reset-password-form'

  events:
    'submit @ui.form': 'submit'

  initialize: =>
    Backbone.Validation.bind @

  submit: (ev) =>
    ev.preventDefault()
    @model.set @ui.form.serializeObject()
    if @model.isValid true
      @trigger 'next'

class ResetSuccessView extends Marionette.ItemView

  template: Templates.auth.reset_password_success

module.exports = class ResetPasswordView extends Marionette.LayoutView

  template: Templates.auth.sign_up

  regions:
    signUp: '#gc-signup-region'

  initialize: =>
    @formView = new ResetFormView model: new ResetPasswordModel
    @successView = new ResetSuccessView
    @listenTo @formView, 'next', @nextStep
    @listenTo @successView, 'final', @final

  onShow: =>
    @signUp.show @formView

  nextStep: =>
    @signUp.show @successView

  final: (dataStep2) =>
    true
