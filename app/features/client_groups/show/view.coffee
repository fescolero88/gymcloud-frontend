define [
  'views/trainer/clients/client-group-view'
  './header/view'
  'views/trainer/clients/client-group-nav-view'
  './template'
], (
  ClientGroupView
  ClientGroupHeaderView
  ClientGroupNavView
  template
) ->

  class GroupShowView extends ClientGroupView

    template: template

    initialize: (data) ->
      @isDroppable = true

      @headerView = new ClientGroupHeaderView
        model: @model
        viewType: @viewType
      @navView = new ClientGroupNavView
        itemId: @itemId
        viewType: @viewType

      @listenTo @navView, 'navView', @loadCenterView

      App.vent.on 'drag:complete', @assignDragged

      @on 'load:view', @loadView