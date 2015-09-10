define [
  'views/trainer/clients/client-group-header-view'
  'views/trainer/clients/group-form-modal-view'
  './template'
], (
  OldClientGroupHeaderView
  GroupFormModalView
  template
) ->
  class ClientGroupHeaderView extends OldClientGroupHeaderView

    template: template

    initialize: ->
      @modalView = new GroupFormModalView(model: @model)

    onRender: ->
      @clientForm.show(@modalView)

    showClientEditModal: (ev) ->
      ev.preventDefault()

      @listenTo clientFormModal, 'modal:close', =>
        @ui.clientFormModal.modal('hide')
      @listenTo(clientFormModal, 'avatarChange', @render)

      @ui.clientFormModal.modal('show')