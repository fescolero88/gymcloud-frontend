define [
  'templates/prototype/payment_info'
  'templates/prototype/trial_ends_soon'
], (
  paymentInfoTemplate
  trialEndsSoonTemplate
) ->

  class TemplateRenderer extends Marionette.ItemView
    constructor: (templateName) ->
      templateHash = {
        'payment-info': paymentInfoTemplate
        'trial-ends-soon': trialEndsSoonTemplate
      }
      @template = templateHash[templateName]
      super

    onShow: ->
      $('body').attr('class', 'auth')
