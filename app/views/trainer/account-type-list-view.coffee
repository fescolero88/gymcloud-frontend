define [
  'backbone.marionette'
  'views/trainer/account-type-item-view'
], (
  Marionette
  AccountTypeItemView
) ->
  class AccountTypeListView extends Marionette.CollectionView

    template: false

    tagName: 'ul'

    childView: AccountTypeItemView