define [
  'views/trainer/clients/client-group-view'
  './header/view'
  './navigation/view'
  './clients/view'
  './assigned_templates/view'
  './template'
], (
  ClientGroupView
  ClientGroupHeaderView
  ClientGroupNavView
  MembersView
  AssignedTemplatesListView
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
        model: @model
        collection: @model.clients

      @listenTo(@navView, 'navView', @loadCenterView)
      @listenTo(@navView, 'content-nav:delete', @_showRemoveModal)
      @listenTo(@navView, 'content-nav:tab', @_changeTab)
      @listenTo(App.vent, 'drag:complete', @assignDragged)
      @listenTo(@, 'load:view', @loadView)

    onShow: ->
      @getRegion('header').show(@headerView)
      @getRegion('nav').show(@navView)
      @getRegion('leftside').show(@centerView)
      # @getRegion('rightside').show(@activityView)
      # @navView.navigate @assign

    _showRemoveModal: ->
      @centerView.showRemoveClient()

    _changeTab: (tabName) ->
      if tabName == 'clients'
        View = MembersView
      else
        View = AssignedTemplatesListView
      view = new View
        model: @model
        collection: @model[tabName]

      @getRegion('leftside').show(view)
