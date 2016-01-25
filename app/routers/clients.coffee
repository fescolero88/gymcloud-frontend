define [
  'models/client'
  'models/client_group'
  'collections/clients'
  'collections/client_groups'
  'views/trainer/clients/clients-view'
  'views/trainer/clients/client-list-view'
  'views/trainer/clients/group-list-view'
  'features/client_groups/show/view'
], (
  Client
  ClientGroup
  Clients
  ClientGroups
  ClientsView
  ClientListView
  GroupListView
  ClientGroupView
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'clients(/)(/:view_type)': 'both'

      'clients/id/:id/:assign(/)': 'client'
      'clients/id/:id/:assign/:key(/)': 'client'

      'client_groups/id/:id/:assign(/)': 'group'
      'client_groups/id/:id/:assign/:key(/)': 'group'

      'tr/me/:assign(/)': 'me'
      'tr/me/:assign/:key(/)': 'me'

      'client_groups/:id(/)': 'clientGroupShow'

  class Controller extends Marionette.Controller

    both: (viewType) ->
      user = App.request 'current_user'
      uid = user.get('id')
      if uid
        @renderClientList(uid)
      else
        @listenToOnce user, 'sync', =>
          @renderClientList(uid, viewType)

    client: (id, assign, key) ->
      @clientOrGroup 'clients', id, assign, key

    group: (id, assign, key) ->
      @clientOrGroup 'client_groups', id, assign, key

    me: (assign, key) ->
      assign = assign || 'exercises'
      @clientOrGroup 'clients', 0, assign, key

    clientGroupShow: (id) ->
      user = App.request('current_user')
      clientGroup = user.client_groups.get(id)
      clientGroup ||= new ClientGroup(id: id)

      clientGroup.fetch()
      view = new ClientGroupView
        itemModel: clientGroup
        model: clientGroup
        itemId: id
      @_showView(view)

    renderClientList: (uid, viewType) ->
      view = new ClientsView
        viewType: viewType
      @_showView(view)

      clients = new Clients
      clients.url = "#{clients.url}/#{uid}/collections/clients"
      clientGroups = new ClientGroups
      clientGroups.url = "#{clientGroups.url}/#{uid}/collections/client_groups"
      clientsView = new ClientListView
        collection: clients
      groupsView = new GroupListView
        collection: clientGroups

      if viewType is 'individuals'
        @initializeSplashListeners(clients, view, viewType)
        clients.fetch()
        view.clients.show(clientsView)
      else if viewType is 'groups'
        @initializeSplashListeners(clientGroups, view, viewType)
        clientGroups.fetch()
        view.groups.show(groupsView)
      else
        view.clients.show(clientsView)
        view.groups.show(groupsView)

        $.when(clients.fetch(), clientGroups.fetch())
          .then (clientData, groupData) ->
            # if no data is present on both individual and group show splash
            if clientData[0].length is 0 and groupData[0].length is 0
              view.ui.splash.removeClass 'hidden'
              view.clients.$el.addClass 'hidden'
              view.groups.$el.addClass 'hidden'

      view.initRegionListeners()

    initializeSplashListeners: (collection, view, viewType) ->
      if viewType is 'individuals' or viewType is 'groups'
        regionName = if viewType is 'individuals' then 'clients' else 'groups'
        viewTypeUI = view.ui["#{regionName}Region"]

        collection.on 'sync', (col) ->
          if col.length is 0
            view.ui.splash.removeClass 'hidden'
            viewTypeUI.addClass 'hidden'

    clientOrGroup: (type, id, assign, key) ->
      mainView = App.request('app:layouts:main')
      currentViewName = mainView.content.currentView?.constructor.name
      if currentViewName is 'ClientGroupView'
        mainView.content.currentView.trigger 'load:view', assign, key
      else
        if id > 0
          if type is 'clients'
            itemModel = new Client
            itemModel.url = "/api/mobile/clients/#{id}"
          else
            itemModel = new ClientGroup
            itemModel.url = "/api/mobile/client_groups/#{id}"
        else
          itemModel = new Client
          itemModel.url = '/api/mobile/me'
        itemModel.fetch()

        recentActivity = new Activities
        if id > 0
          if type is 'clients'
            recentActivity.url = "/api/mobile/clients/#{id}/notifications"
          else
            recentActivity.url = "/api/mobile/client_groups/#{id}/notifications"
        else
          recentActivity.url = '/api/mobile/notifications'
        recentActivity.loadMore()

        view = new ClientGroupView
          itemModel: itemModel
          recentActivity: recentActivity
          itemId: id
          assign: assign
          key: key
          viewType: type
        @_showView(view)

    _showView: (view) ->
      App.request('views:show', view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
