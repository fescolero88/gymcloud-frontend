define [
  'pages/base/page'
  './template'
  './transactions/view'
  'features/payment/transactions/collection'
], (
  BasePage
  template
  TransactionsView
  TransactionsCollection
) ->

  class Page extends BasePage

    className: 'payments'

    template: template

    behaviors:

      navigation_content_tabs:
        data: [
            id: 'transactions'
            title: 'Transaction History'
          ,
            id: 'details'
            title: 'Payment Details'
        ]

    regions:
      page_content: 'region[data-name="page_content"]'

    initCollection: ->
      collection = new TransactionsCollection
      collection.fetch()
      collection

    initViews: ->
      transactions: ->
        new TransactionsView
          collection: @model.get('data.collection')

      details: ->
        new Marionette.CollectionView
