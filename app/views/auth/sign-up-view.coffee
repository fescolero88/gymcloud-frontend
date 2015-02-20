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
      if @model.get('password') is @model.get('password_confirmation')
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
      if @ui.agree.is ':checked'
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
    $.ajax
      method: 'POST'
      url: '/api/mobile/users'
      dataType: 'json'
      data: JSON.stringify @steps.attributes
      success: (data) =>
        @trigger 'signup:complete'
