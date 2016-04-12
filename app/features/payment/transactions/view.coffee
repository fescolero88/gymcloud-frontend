define [
  './item/view'
], (
  TransactionsItem
) ->

  class TransactionsList extends Marionette.CollectionView

    childView: TransactionsItem
