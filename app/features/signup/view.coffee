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
      facebook_login:
        isSignup: true
        isLinking: false
      google_login:
        isSignup: true
        isLinking: false

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
      'blur input': 'validateInput'

    initialize: (options) ->
      Backbone.Validation.bind @
      @client = options.client

    validateInput: (ev) ->
      $input = $(ev.target)
      input_name = $(ev.target).attr 'name'
      input_value = $(ev.target).val()
      if input_value
        $inputGroup = $input.closest('.form-group')
        error_msg = @model.preValidate input_name, input_value
        @trigger 'switchError', error_msg, $inputGroup

    onRender: ->
      if @client
        @model.set @client
        # hide social signup if triggered by invitation
        @ui.socialSignup.hide()
        @ui.form.find('.gc-signup-with-email-title').hide()
        @ui.form.find('input[name="email"]').attr('disabled', 'disabled')

    createAccount: ->
      # safari autocomplete hack
      fields = [
        'first_name'
        'last_name'
        'email'
        'password'
        'password_confirmation'
      ]

      @model.set _.reduce(fields, ((memo, field) ->
        memo[field] = @$("input[name='#{field}']").val()
        memo
      ), {}, @)

      if @client
        @model.acceptInvite()
      else
        @model.createAccount()

    onAccountCreated: (data, _userProfile)->
      App.request('auth:onSuccess', data)
      @trigger 'signup:complete'
