define [
  './template'
  'features/payment/transactions/view'
], (
  template
  TransactionList
) ->

  class TransactionsView extends Marionette.LayoutView

    template: template

    className: 'transactions'

    behaviors:

      regioned:
        views: [
            region: 'transactions'
            klass: TransactionList
            options: ->
              collection: @collection
        ]
