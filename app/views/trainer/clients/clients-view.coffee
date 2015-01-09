Marionette = require 'backbone.marionette'
MoveToGroupView = require 'views/trainer/clients/move-to-group-view'

module.exports = class ClientsView extends Marionette.LayoutView
  template: Templates.trainer.clients.clients

  events:
    "click .gc-content-nav-checkall": "toggleCheck"
    "click .gc-clients-list-client-chb": "checkAll"
    "click #rm-event": "rmEvent"
    "change .gc-edit-profile-modal-upload-input": "showThumbnail"
    "click .move-to-group-show": "showMovetogroupModal"
    "submit @ui.groupForm": "submitGroupForm"
    "submit .gc-move-to-group-form": "submitMovetogroupForm"
    "submit @ui.clientForm": "submitClientForm"

  ui:
    mainCheckbox: ".gc-content-nav-checkall input[type='checkbox']"
    groupFormModal: "#gc-add-group-modal"
    groupForm: ".group-form"
    clientFormModal: "#gc-add-client-modal"
    clientForm: ".client-form"

  regions:
    'clients': '#clients-region'
    'groups': '#groups-region'
    'move_to_group': '#gc-move-to-group-modal'

  templateHelpers: =>
    view_type: @view_type

  initialize: (view_type)=>
    @view_type = view_type
    @checkButtons()

  toggleCheck: (ev) =>
    checked = @ui.mainCheckbox.is(':checked')
    @$el.find('.gc-clients-list-wrapper').find('input[type=checkbox]').prop('checked', checked)
    @checkButtons()

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
    for check in @$el.find('.gc-clients-list-wrapper').find('input[type=checkbox]')
      if need_toggle?
        if need_toggle != $(check).is(':checked')
          @ui.mainCheckbox.prop 'checked', false
          return
      need_toggle = $(check).is(':checked')
    if need_toggle
      @ui.mainCheckbox.prop 'checked', true

  rmEvent: (ev) =>
    ev.preventDefault()
    @clients.currentView?.trigger 'rm-client'
    @groups.currentView?.trigger 'rm-group'

  showMovetogroupModal: (ev) ->
    ev.preventDefault()
    move_to_group_view = new MoveToGroupView collection: @groups.currentView.collection
    @move_to_group.show move_to_group_view
    @$el.find('#gc-move-to-group-modal').modal('show')

  showThumbnail: (ev) ->
    input = ev.target
    if input.files && input.files[0]
      reader = new FileReader()
      reader.onload = (e)->
        $(ev.target).parents('form').find('.gc-edit-profile-modal-avatar').attr('src', e.target.result)
      reader.readAsDataURL(input.files[0])

  submitMovetogroupForm: (ev) ->
    ev.preventDefault()
    #TODO validation
    clients_id = []
    groups_id = []
    for check in @$el.find('#clients-region').find('input[type=checkbox]:checked')
      clients_id.push $(check).data('id')
    for check in @$el.find('.gc-move-to-group-form').find('input[type=checkbox]:checked')
      groups_id.push $(check).data('id')
    #TODO Submit when will be API

  submitGroupForm: (ev) =>
    ev.preventDefault()
    #TODO validation
    name = $(ev.target).find('input[name=group_name]').val()
    avatar = $(ev.target).find('input[type=file]')
    @groups.currentView.trigger 'submit-group-form', {name, avatar}
    @ui.groupFormModal.modal('hide')

  submitClientForm: (ev) =>
    ev.preventDefault()
    #TODO validation
    avatar = $(ev.target).find('input[type=file]')
    form_data = @ui.clientForm.serializeObject()
    @clients.currentView.trigger 'submit-client-form', {form_data, avatar}
    @ui.clientFormModal.modal('hide')
