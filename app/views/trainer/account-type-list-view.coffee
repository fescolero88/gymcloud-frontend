define [
  'backbone.marionette'
  'views/trainer/account-type-item-view'
], (
  Marionette
  AccountTypeItemView
) ->
  class AccountTypeListView extends Marionette.CollectionView

    tagName: 'ul'

    childView: AccountTypeItemView