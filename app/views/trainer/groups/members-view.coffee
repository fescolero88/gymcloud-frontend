Marionette = require 'backbone.marionette'

ClientCollection = require 'models/trainer/client-collection'

class MembersItemView extends Marionette.ItemView

  template: Templates.trainer.groups.members_item

  tagName: 'li'

  className: 'row padding-0'

module.exports = class MembersView extends Marionette.CompositeView

  template: Templates.trainer.groups.members

  childView: MembersItemView

  childViewContainer: 'ul'

  events:
    "click @ui.rmAssign": "rmAssign"
    "submit @ui.removeForm": "submitRemoveClient"

  ui:
    rmAssign: ".gc-exercises-assign-btn-del"
    removeModal: "#gc-remove-from-group-modal"
    checked: 'input[type=checkbox]:checked'
    removeForm: '.gc-remove-from-group-form'

  childViewOptions: ->
    groupId: @groupId

  initialize: (data) =>
    @groupId = data.groupId
    App.vent.on 'content-nav:delete', @showRemoveClient

  onDestroy: =>
    App.vent.off 'content-nav:delete', @showRemoveClient

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
    clientsId = []
    for check in @$el.find('input[type=checkbox]:checked')
      clientsId.push $(check).data('id')
    data =
      client_ids: clientsId
      client_group_ids: [@groupId]

    @ui.removeModal.modal 'hide'

    $.ajax
      url: "/api/mobile/client_groups/remove"
      type: 'POST'
      data: JSON.stringify data
      dataType: 'json'
      statusCode:
        201: (data) =>
          @collection.fetch()

  searchItems: (models) ->
    listItems = []
    for model in models
      item = new Object
      item.id = model.get 'id'
      item.last_name = model.get 'last_name'
      item.first_name = model.get 'first_name'
      item.color = model.get 'avatar_background_color'
      item.url = model.get 'avatar_url'
      listItems.push item
    listItems

  addMember: (item) ->
    data =
      client_ids: [item.id]
      client_group_ids: [@groupId]

    $.ajax
      url: "/api/mobile/client_groups/add"
      type: 'POST'
      data: JSON.stringify data
      dataType: 'json'
      statusCode:
        201: (data) =>
          @collection.fetch()

  initSearchSelect: =>
    clientCollection = new ClientCollection
    clientCollection.fetch().then =>
      options = @searchItems clientCollection.models
      this_ = @
      @$el.find('.live-search').selectize
        #openOnFocus: false
        hideSelected: true
        valueField: 'id'
        labelField: 'first_name'
        searchField: ['first_name', 'last_name']
        options: options
        onItemAdd: (value, $item) ->
          @clear()
          this_.addMember {first_name: $item.data('first_name'), last_name: $item.data('last_name'), id: value}
        render:
          item: (item, escape) ->
            return "<div><span class='avatar' style='background-color: " +  \
              item.color + ";'><img src='" + item.url + "'></span>" + \
              escape(item.first_name) + ' ' + escape(item.last_name) + '</div>'
          option: (item, escape) ->
            return "<div><span class='avatar' style='background-color: " +  \
              item.color + ";'><img src='" + item.url + "'></span>" + \
              escape(item.first_name) + ' ' + escape(item.last_name) + '</div>'
