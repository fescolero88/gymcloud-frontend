define [
  'views/trainer/account-type-item-view'
], (
  AccountTypeItemView
) ->
  class AccountTypeListView extends Marionette.CollectionView

    tagName: 'ul'

    childView: AccountTypeItemView

    childEvents:
      'selected:changed': 'selectedChanged'

    childViewOptions:
      'selected': false

    selectedChanged: =>
      selected = @collection.findWhere 'selected': true
      if selected
        selected.set 'selected', false
