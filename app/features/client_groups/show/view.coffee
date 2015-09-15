define [
  'views/trainer/clients/client-group-view'
  './header/view'
  './navigation/view'
  './clients/view'
  './template'
], (
  ClientGroupView
  ClientGroupHeaderView
  ClientGroupNavView
  MembersView
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
      @centerView = new MembersView
        groupId: @model.id
        clientGroup: @model
        collection: @model.clients

      @listenTo(@navView, 'navView', @loadCenterView)
      @listenTo(@navView, 'content-nav:delete', @_showRemoveModal)

      App.vent.on 'drag:complete', @assignDragged

      @on('load:view', @loadView)


    onShow: ->
      @getRegion('header').show(@headerView)
      @getRegion('nav').show(@navView)
      @getRegion('leftside').show(@centerView)
      # @getRegion('rightside').show(@activityView)
      # @navView.navigate @assign

    _showRemoveModal: ->
      @centerView.showRemoveClient()