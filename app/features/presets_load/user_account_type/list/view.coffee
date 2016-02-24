define [
  './item/view'
], (
  AccountTypeItemView
) ->
  class AccountTypeListView extends Marionette.CollectionView

    tagName: 'ul'

    childView: AccountTypeItemView