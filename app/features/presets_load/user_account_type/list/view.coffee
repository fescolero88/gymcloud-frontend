define [
  './item/view'
  './collection'
], (
  AccountTypeItemView
  UserAccountTypesCollection
) ->

  class AccountTypeListView extends Marionette.CollectionView

    tagName: 'ul'

    childView: AccountTypeItemView

    initialize: ->
      @collection = new UserAccountTypesCollection
      @collection.fetch()
