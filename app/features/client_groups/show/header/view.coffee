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

    showClientEditModal: (ev) ->
      App.request('modal:groups', @model)
