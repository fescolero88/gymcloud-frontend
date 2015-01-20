Marionette = require 'backbone.marionette'

ClientFormModalView = require 'views/trainer/clients/client-form-modal-view'
GroupFormModalView = require 'views/trainer/clients/group-form-modal-view'


module.exports = class ClientGroupHeaderView extends Marionette.LayoutView
  template: Templates.trainer.clients.client_group_header
  autoRender: false

  modelEvents:
    "sync": "render"

  events:
    "submit @ui.inviteForm": "submitClientForm"
    "click .show-client-form": "showClientEditModal"

  regions:
    'clientForm': '#gc-edit-client-modal'

  ui:
    inviteModal: '#gc-invite-client-modal'
    inviteForm: '.invite-client-form'
    clientFormModal: "#gc-edit-client-modal"

  initialize: (data)->
    @viewType = data.viewType

  templateHelpers: ->
    if @viewType is 'clients'
      view_type: 1
    else
      view_type: 0

  submitClientForm: (ev)->
    #TODO validation
    ev.preventDefault()
    formData = @ui.inviteForm.serializeObject()

    $.ajax
      url: "#{@model.url}/invite"
      type: 'POST'
      data: JSON.stringify formData
      dataType: 'json'
      success: =>
        @ui.inviteModal.modal('hide')
      error: (data)=>
        errorMsg = data.responseJSON.error
        if errorMsg?
          $input = @ui.inviteForm.find("input[name=email]")
          $inputGroup = $input.closest('.form-group')
          $inputGroup.removeClass('gc-valid').addClass('gc-invalid')
          $inputGroup.find('.gc-error-message').text(errorMsg)


  showClientEditModal: (ev) ->
    ev.preventDefault()
    if @viewType is 'clients'
      clientFormModal = new ClientFormModalView model: @model
    else
      clientFormModal = new GroupFormModalView model: @model

    @listenTo clientFormModal, 'closeModal', =>
      @ui.clientFormModal.modal('hide')
    @listenTo clientFormModal, 'avatarChange', =>
      @render()

    @clientForm.show clientFormModal
    @ui.clientFormModal.modal('show')
