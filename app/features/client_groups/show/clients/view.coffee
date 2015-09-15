define [
  './item/view'
  './template'
], (
  MembersItemView
  template
) ->
  class MembersView extends Marionette.CompositeView

    template: template

    childView: MembersItemView

    childViewContainer: 'ul'

    events:
      'click @ui.rmAssign': 'rmAssign'
      'submit @ui.removeForm': 'submitRemoveClient'

    ui:
      rmAssign: '.gc-exercises-assign-btn-del'
      removeModal: '#gc-remove-from-group-modal'
      checked: 'input[type=checkbox]:checked'
      removeForm: '.gc-remove-from-group-form'

    childViewOptions: ->
      groupId: @groupId

    initialize: (data) ->
      @groupId = data.groupId
      @clientGroup = data.clientGroup

    onShow: ->
      @initSearchSelect()

    rmAssign: (ev) =>
      ev.preventDefault()
      assignId = $(ev.currentTarget).data 'id'
      model = @collection.get assignId
      model.destroy()

    showRemoveClient: (ev) =>
      @ui.removeModal.modal 'show'

    submitRemoveClient: (ev) ->
      ev.preventDefault()

      currentUser = App.request('current_user')
      clientCollection = currentUser.clients

      for check in @$el.find('input[type=checkbox]:checked')
        id = $(check).data('id')
        user = clientCollection.get(id)
        @clientGroup.removeUser(user).done =>
          @initSearchSelect()

      @ui.removeModal.modal 'hide'

    searchItems: (models) ->
      _.map models, (model) ->
        id: model.get('id')
        last_name: model.get('user_profile.last_name')
        first_name: model.get('user_profile.first_name')
        color: model.get('user_profile.avatar_background_color')
        url: model.get('user_profile.avatar.thumb.url')

    addMember: (item) ->
      currentUser = App.request('current_user')
      clientCollection = currentUser.clients
      user = clientCollection.get(item.id)
      @clientGroup.addUser(user).done =>
        @initSearchSelect()

    initSearchSelect: ->
      currentUser = App.request('current_user')
      clientCollection = currentUser.clients
      toSelect = clientCollection.difference(@clientGroup.clients.models)
      options = @searchItems(toSelect)
      self = this
      @$el.find('.live-search').selectize
        hideSelected: true
        valueField: 'id'
        labelField: 'first_name'
        searchField: ['first_name', 'last_name']
        options: options
        onItemAdd: (value, $item) ->
          @clear()
          self.addMember(id: value)
        render:
          item: (item, escape) ->
            return "<div><span class='avatar' style='background-color: " +  \
              item.color + ";'><img src='" + item.url + "'></span>" + \
              escape(item.first_name) + ' ' + escape(item.last_name) + '</div>'
          option: (item, escape) ->
            return "<div><span class='avatar' style='background-color: " +  \
              item.color + ";'><img src='" + item.url + "'></span>" + \
              escape(item.first_name) + ' ' + escape(item.last_name) + '</div>'