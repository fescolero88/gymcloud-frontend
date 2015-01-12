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
    checkedCounter: ".gc-clients-nav-right p"

  regions:
    'clients': '#clients-region'
    'groups': '#groups-region'
    'moveToGroup': '#gc-move-to-group-modal'

  templateHelpers: =>
    view_type: @viewType

  initialize: (viewType)=>
    @viewType = viewType
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
    count = @$el.find('.gc-clients-list-wrapper').find('input[type=checkbox]:checked').length
    if count
      @ui.checkedCounter.removeClass('hidden').find('span').text(count)
    else
      @ui.checkedCounter.addClass('hidden')

  rmEvent: (ev) =>
    ev.preventDefault()
    @clients.currentView?.trigger 'rm-client'
    @groups.currentView?.trigger 'rm-group'

  showMovetogroupModal: (ev) ->
    ev.preventDefault()
    moveToGroupView = new MoveToGroupView collection: @groups.currentView.collection
    @moveToGroup.show moveToGroupView
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
    clientsId = []
    groupsId = []
    for check in @$el.find('#clients-region').find('input[type=checkbox]:checked')
      clientsId.push $(check).data('id')
    for check in @$el.find('.gc-move-to-group-form').find('input[type=checkbox]:checked')
      groupsId.push $(check).data('id')
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
    formData = @ui.clientForm.serializeObject()
    @clients.currentView.trigger 'submit-client-form', {formData, avatar}
    @ui.clientFormModal.modal('hide')
