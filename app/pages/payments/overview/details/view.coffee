define [
  './template'
  'features/payment/subscription/view'
  'features/payment/payment_methods/view'
], (
  template
  SubscriptionView
  PaymentMethodsView
) ->

  class PaymentDetailsView extends Marionette.LayoutView

    template: template

    className: 'payment-details'

    behaviors:

      regioned:
        views: [
            region: 'subscription'
            klass: SubscriptionView
          ,
            region: 'payment_methods'
            klass: PaymentMethodsView
        ]
