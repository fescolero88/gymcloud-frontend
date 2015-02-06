config = require 'config'
Marionette = require 'backbone.marionette'

module.exports = class SignUpStep1 extends Marionette.ItemView
  template: Templates.auth.sign_up_1

  ui:
    'types': '.gc-trainer-type'
    'radio': '.gc-trainer-type input[type=radio]'
    'form': "#gc-signup-step-1"

  events:
    'change @ui.radio': 'switchType'
    'submit @ui.form': 'submit'

  switchType: (ev) =>
    if $(ev.currentTarget).is ':checked'
      @ui.types.removeClass 'active'
      $(ev.currentTarget).closest('.gc-trainer-type').addClass 'active'

  submit: (ev) =>
    ev.preventDefault()
    @trigger 'next'

module.exports = class SignUpStep2 extends Marionette.ItemView
  template: Templates.auth.sign_up_2

module.exports = class SignUpView extends Marionette.LayoutView
  template: Templates.auth.sign_up

  regions:
    'wrap': '.page-wrap'

  initialize: =>
    @step1 = new SignUpStep1
    @step2 = new SignUpStep2
    @listenTo @step1, 'next', @nextStep

  onShow: =>
    @wrap.show @step1

  nextStep: =>
    @wrap.show @step2
