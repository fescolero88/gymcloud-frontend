define [
  'templates/prototype/payment_info'
  'templates/prototype/trial_ended'
  'templates/prototype/trial_ends_soon'
], (
  paymentInfoTemplate
  trialEndedTemplate
  trialEndsSoonTemplate
) ->

  class TemplateRenderer extends Marionette.ItemView
    constructor: (templateName) ->
      templateHash = {
        'payment-info': paymentInfoTemplate
        'trial-ended': trialEndedTemplate
        'trial-ends-soon': trialEndsSoonTemplate
      }
      @template = templateHash[templateName]
      super

    onShow: ->
      $('body').attr('class', 'auth')
