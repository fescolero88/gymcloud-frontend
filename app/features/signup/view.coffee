define [
  './model'
  './template'
], (
  AccountModel
  Template
) ->

  class SignupView extends Marionette.ItemView

    template: Template

    modelEvents:
      'account:created': 'onAccountCreated'

    behaviors:
      form_validation: true

      stickit:
        bindings:
          '[data-bind="first_name"]': 'first_name'
          '[data-bind="last_name"]': 'last_name'
          '[data-bind="email"]': 'email'
          '[data-bind="password"]': 'password'
          '[data-bind="password_confirmation"]': 'password_confirmation'
          '[data-bind="agree"]': 'agree'

    ui:
      'form': 'form.gc-signup-form'
      'socialSignup': '.gc-login-social'

    events:
      'submit @ui.form': 'createAccount'

    initialize: (options) ->
      Backbone.Validation.bind @
      @client = options.client

    onRender: ->
      if @client
        @model.set @client
        # hide social signup if triggered by invitation
        @ui.socialSignup.hide()
        @ui.form.find('.gc-signup-with-email-title').hide()
        @ui.form.find('input[name="email"]').attr('disabled', 'disabled')

    createAccount: ->
      if @client
        @model.acceptInvite()
      else
        @model.createAccount()

    onAccountCreated: ->
      @trigger 'signup:complete'
