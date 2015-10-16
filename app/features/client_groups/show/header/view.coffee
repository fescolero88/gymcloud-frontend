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

    onShow: ->
      @clientForm.show(@modalView)

    showClientEditModal: (ev) ->
      @listenTo @modalView, 'closeModal', =>
        $('.modal-backdrop.fade.in').remove()
        @ui.clientFormModal.modal('hide')
      @listenTo(@modalView, 'avatarChange', @render)

      @ui.clientFormModal.modal('show')
