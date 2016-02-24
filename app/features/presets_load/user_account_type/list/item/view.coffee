define [
  './template'
], (
  template
) ->
  class AccountTypeItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'gc-account-type-item'

    events:
      'click': 'changeSelected'

    behaviors:

      stickit:
        bindings:
          'h5': 'name'
          '.gc-account-selected':
            classes:
              assigned: 'is_selected'
          ':el':
            classes:
              active: 'is_selected'

    initialize: ->
      user = App.request('current_user')
      @userSettings = settings = user.user_settings
      @model.set(is_selected: @model.id is settings.get('user_account_type_id'))
      @listenTo settings, 'change:user_account_type_id', (model, value, _) =>
        @model.set(is_selected: @model.id is value)

    changeSelected: ->
      currentId = @userSettings.get('user_account_type_id')
      return false if currentId is @model.id

      @userSettings.save({
        user_account_type_id: @model.id
      }, wait: true).then ->
        App.request('messenger:explain', 'user.account_type.changed')
