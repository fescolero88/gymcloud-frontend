define [
  './template'
  './list/view'
  './collection'
], (
  template
  UserAccountTypeListView
  UserAccountTypesCollection
) ->

  class AccountTypeModalView extends Marionette.LayoutView

    template: template

    behaviors:

      regioned:
        views: [
            region: 'user_account_types'
            klass: UserAccountTypeListView
            options: ->
              collection = new UserAccountTypesCollection
              collection.fetch()
              collection: collection
        ]

    events:
      'click a.gc-change-account-type': '_goNext'

    _goNext: ->
      @trigger('changeView', 'next')
