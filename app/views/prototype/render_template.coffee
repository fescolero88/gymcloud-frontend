define [
  'templates/prototype/payment_info'
], (
  paymentInfoTemplate
) ->

  class TemplateRenderer extends Marionette.ItemView
    constructor: (templateName) ->
      templateHash = {
        'payment-info': paymentInfoTemplate
      }
      @template = templateHash[templateName]
      super

    onShow: ->
      $('body').attr('class', 'auth')
