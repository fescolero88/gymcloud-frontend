config = require 'config'
Marionette = require 'backbone.marionette'
Backbone = require 'backbone'
moment = require 'moment'

SignUpStep1Model = require 'models/auth/signup-step1-model'
SignUpStep2Model = require 'models/auth/signup-step2-model'

FormValidationBehaviour = require 'views/helpers/form-validation-behaviour'

class SignUpStep1 extends Marionette.ItemView

  template: Templates.auth.sign_up_1

  behaviors:
    FormValidationBehaviour:
      behaviorClass: FormValidationBehaviour

  ui:
    types: '.gc-trainer-type'
    radio: '.gc-trainer-type input[type=radio]'
    form: '#gc-signup-step-1'
    emailGroup: '.gc-email-form-group'

  events:
    'change @ui.radio': 'switchType'
    'submit @ui.form': 'submit'

  initialize: =>
    Backbone.Validation.bind @

  switchType: (ev) =>
    if $(ev.currentTarget).is ':checked'
      @ui.types.removeClass 'active'
      $(ev.currentTarget).closest('.gc-trainer-type').addClass 'active'

  submit: (ev) =>
    ev.preventDefault()
    formData = @ui.form.serializeObject()
    for key, value of formData
      if key is 'trainer-type'
        formData[key] = parseInt value
    @model.set formData
    if @model.isValid true
      $.ajax
        method: 'GET'
        url: '/api/mobile/users/is_email_in_use'
        dataType: 'json'
        data:
          email: @model.get 'email'
        success: (data) =>
          @trigger 'next', @model
        statusCode:
          403: (data) =>
            @trigger 'switchError', data.responseJSON.message.email, @ui.emailGroup

class SignUpStep2 extends Marionette.ItemView

  template: Templates.auth.sign_up_2

  behaviors:
    FormValidationBehaviour:
      behaviorClass: FormValidationBehaviour

  ui:
    form: '#gc-signup-step-2'
    dateInputFroup: '.gc-date-selectors'

  events:
    'submit @ui.form': 'submit'

  initialize: =>
    Backbone.Validation.bind @
    @on 'signup:errors', @returnedErrors

  submit: (ev) =>
    ev.preventDefault()
    formData = @ui.form.serializeObject()
    for key, value of formData
      if key is 'gender'
        formData[key] = parseInt value
    @model.set formData
    if @model.isValid true
      birth = "#{@model.get('birth_year')}-#{@model.get('birth_month')}-#{@model.get('birth_day')}"
      if moment(birth, "YYYY-MM-DD", true).isValid()
        @model.set 'dob', birth
        @trigger 'final', @model
      else
        @trigger 'switchError', 'Incorrect date', @ui.dateInputFroup

  stepBack: (ev) =>
    @trigger 'signup:back'

  returnedErrors: (errors) =>
    for name, error_msg of errors
      $input = @$el.find("input[name=#{name}]")
      $inputGroup = $input.closest('.form-group')
      @trigger 'switchError', error_msg[0], $inputGroup

module.exports = class SignUpView extends Marionette.LayoutView

  template: Templates.auth.empty_layout

  regions:
    signUp: '#gc-default-region'

  initialize: =>
    @step1 = new SignUpStep1
      model: new SignUpStep1Model
    @step2 = new SignUpStep2
      model: new SignUpStep2Model
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
    $.ajax
      method: 'POST'
      url: '/api/mobile/users'
      dataType: 'json'
      data: JSON.stringify @steps.attributes
      success: (data) =>
        App.vent.trigger 'spinner:global:stop'
        @trigger 'signup:complete'
      statusCode:
        403: (data) =>
          if data.responseJSON.error
            @step2.trigger 'signup:errors', data.responseJSON.message
