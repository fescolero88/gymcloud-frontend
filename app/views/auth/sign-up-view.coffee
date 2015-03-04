config = require 'config'
Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

SignUpStep1Model = require 'models/auth/signup-step1-model'
SignUpStep2Model = require 'models/auth/signup-step2-model'

class SignUpStep1 extends Marionette.ItemView

  template: Templates.auth.sign_up_1

  ui:
    'types': '.gc-trainer-type'
    'radio': '.gc-trainer-type input[type=radio]'
    'form': "#gc-signup-step-1"
    'password': "#gc-signup-password-1"
    'password_confirmation': "#gc-signup-password-2"

  events:
    'change @ui.radio': 'switchType'
    'submit @ui.form': 'submit'

  initialize: =>
    Backbone.Validation.bind @

  switchType: (ev) =>
    if $(ev.currentTarget).is ':checked'
      @ui.types.removeClass 'active'
      $(ev.currentTarget).closest('.gc-trainer-type').addClass 'active'

  switchError: (error_msg, $inputGroup) =>
    if error_msg
      $inputGroup.removeClass('gc-valid').addClass('gc-invalid')
      $inputGroup.find('.gc-valid-icon').addClass('hide')
      $inputGroup.find('.gc-error-message').text(error_msg)
    else
      $inputGroup.removeClass('gc-invalid').addClass('gc-valid')
      $inputGroup.find('.gc-valid-icon').removeClass('hide')
      $inputGroup.find('.gc-error-message').text("")

  submit: (ev) =>
    ev.preventDefault()
    formData = @ui.form.serializeObject()
    for key, value of formData
      if key is 'trainer-type'
        formData[key] = parseInt value
    @model.set formData
    if @model.isValid true
      @trigger 'next', @model

class SignUpStep2 extends Marionette.ItemView

  template: Templates.auth.sign_up_2

  ui:
    'form': "#gc-signup-step-2"
    'agree': '.gc-signup-agree'

  events:
    'submit @ui.form': 'submit'

  initialize: =>
    Backbone.Validation.bind @

  submit: (ev) =>
    ev.preventDefault()
    formData = @ui.form.serializeObject()
    for key, value of formData
      if key is 'gender'
        formData[key] = parseInt value
    @model.set formData
    if @model.isValid true
      @trigger 'final', @model

module.exports = class SignUpView extends Marionette.LayoutView

  template: Templates.auth.sign_up

  regions:
    'signUp': '#gc-signup-region'

  initialize: =>
    @step1 = new SignUpStep1 model: new SignUpStep1Model
    @step2 = new SignUpStep2 model: new SignUpStep2Model
    @listenTo @step1, 'next', @nextStep
    @listenTo @step2, 'final', @final

  onShow: =>
    @signUp.show @step1

  nextStep: (dataStep1) =>
    @steps = dataStep1
    @signUp.show @step2

  final: (dataStep2) =>
    @steps.set dataStep2.attributes
    @steps.set 'address', "#{@steps.get('state')}, #{@steps.get('city')}, #{@steps.get('address')}"
    @steps.set 'birth', "#{@steps.get('birth_year')}-#{@steps.get('birth_month')}-#{@steps.get('birth_day')}"
    $.ajax
      method: 'POST'
      url: '/api/mobile/users'
      dataType: 'json'
      data: JSON.stringify @steps.attributes
      success: (data) =>
        App.vent.trigger "spinner:global:stop"
        if data.errors
            for name, error_msg of data.errors
              $input = @$el.find("input[name=#{name}]")
              $inputGroup = $input.closest('.form-group')
              @switchError error_msg[0], $inputGroup
        else
          @trigger 'signup:complete'
