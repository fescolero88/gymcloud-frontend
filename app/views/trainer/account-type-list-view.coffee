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

    childEvents:
      'selected:changed': 'selectedChanged'

    childViewOptions:
      'selected': false

    selectedChanged: =>
      selected = @collection.findWhere 'selected': true
      if selected
        selected.set 'selected', false