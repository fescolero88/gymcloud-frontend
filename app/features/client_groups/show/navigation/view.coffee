define [
  'views/trainer/clients/client-group-nav-view'
  './template'
], (
  OldClientGroupNavView
  template
) ->
  class ClientGroupNavView extends OldClientGroupNavView

    template: template

    deleteButtonClick: (ev) ->
      @trigger('content-nav:delete')