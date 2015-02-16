Marionette = require 'backbone.marionette'

MoveToGroupView = require 'views/trainer/clients/move-to-group-view'

ClientFormModalView = require 'views/trainer/clients/client-form-modal-view'
ClientModel = require 'models/trainer/client-model'

GroupFormModalView = require 'views/trainer/clients/group-form-modal-view'
GroupModel = require 'models/trainer/group-model'


module.exports = class ClientsView extends Marionette.LayoutView
  template: Templates.trainer.clients.clients

  events:
    "click .gc-content-nav-checkall": "toggleCheck"
    "click .gc-clients-list-client-chb": "checkAll"
    "click #rm-event": "rmEvent"
    "click .move-to-group-show": "showMovetogroupModal"
    "click .show-client-form": "showClientAddModal"
    "click .show-group-form": "showGroupAddModal"
    "submit .gc-move-to-group-form": "submitMovetogroupForm"

  ui:
    mainCheckbox: ".gc-content-nav-checkall input[type='checkbox']"
    groupFormModal: "#gc-add-group-modal"
    groupForm: ".group-form"
    clientFormModal: "#gc-add-client-modal"
    checkedCounter: ".gc-clients-nav-right p"
    moveToGroupModal: '#gc-move-to-group-modal'

  regions:
    'clients': '#clients-region'
    'groups': '#groups-region'
    'moveToGroup': '#gc-move-to-group-modal'
    'clientForm': '#gc-add-client-modal'
    'groupForm': '#gc-add-group-modal'

  templateHelpers: =>
    view_type: @viewType

  initialize: (viewType)=>
    viewType = 'clients' if typeof viewType is 'object'
    @viewType = viewType
    @checkButtons()

  initRegionListeners: =>
    @listenTo @clients.currentView, 'individual:move', @showMovetogroupModal

  toggleCheck: (ev) =>
    checked = @ui.mainCheckbox.is(':checked')
    @$el.find('.gc-clients-list-wrapper').find('input[type=checkbox]').prop('checked', checked)
    @checkButtons()
    @countSelected()

  checkButtons: ->
    if @$el.find('#clients-region').find('input[type=checkbox]:checked').length
      @$el.find('.move-to-group-show').show()
    else
      @$el.find('.move-to-group-show').hide()
    if @$el.find('input[type=checkbox]:checked').length
      @$el.find('#rm-event').show()
    else
      @$el.find('#rm-event').hide()

  checkAll: (ev) =>
    @checkButtons()
    @countSelected()
    for check in @$el.find('.gc-clients-list-wrapper').find('input[type=checkbox]')
      if needToggle?
        if needToggle != $(check).is(':checked')
          @ui.mainCheckbox.prop 'checked', false
          return
      needToggle = $(check).is(':checked')
    if needToggle
      @ui.mainCheckbox.prop 'checked', true

  countSelected: =>
    count = @$el.find('.gc-clients-list-ind').find('input[type=checkbox]:checked').length
    if count
      @ui.checkedCounter.removeClass('hidden').find('span').text(count)
    else
      @ui.checkedCounter.addClass('hidden')

  rmEvent: (ev) =>
    ev.preventDefault()
    @clients.currentView?.trigger 'rm-client'
    @groups.currentView?.trigger 'rm-group'
    @checkAll()

  showClientAddModal: (ev) ->
    ev.preventDefault()
    clientModel = new ClientModel
    clientFormModal = new ClientFormModalView model: clientModel

    @listenTo clientFormModal, 'closeModal', =>
      @ui.clientFormModal.modal('hide')
    @listenTo clientFormModal, 'addToClientsCollection', (model)=>
      @clients.currentView.collection.add model

    @clientForm.show clientFormModal
    @ui.clientFormModal.modal('show')

  showGroupAddModal: (ev) ->
    ev.preventDefault()
    groupModel = new GroupModel
    groupFormModal = new GroupFormModalView model: groupModel

    @listenTo groupFormModal, 'closeModal', =>
      @ui.groupFormModal.modal('hide')
    @listenTo groupFormModal, 'addToGroupsCollection', (model)=>
      @groups.currentView.collection.unshift model

    @groupForm.show groupFormModal
    @ui.groupFormModal.modal('show')

  showMovetogroupModal: (ev) =>
    ev?.preventDefault()
    moveToGroupView = new MoveToGroupView collection: @groups.currentView.collection
    @moveToGroup.show moveToGroupView
    @ui.moveToGroupModal.modal('show')

  submitMovetogroupForm: (ev) ->
    ev.preventDefault()
    #TODO validation
    clientsId = []
    groupsId = []
    for check in @$el.find('#clients-region').find('input[type=checkbox]:checked')
      clientsId.push $(check).data('id')
    for check in @$el.find('.gc-move-to-group-form').find('input[type=checkbox]:checked')
      groupsId.push $(check).data('id')
    data =
      client_ids: clientsId
      client_group_ids: groupsId

    @ui.moveToGroupModal.modal('hide')

    $.ajax
      url: "/api/mobile/client_groups/add"
      type: 'POST'
      data: JSON.stringify data
      dataType: 'json'
      success: =>
        @$el.find('#clients-region').find('input[type=checkbox]:checked').removeAttr('checked')
