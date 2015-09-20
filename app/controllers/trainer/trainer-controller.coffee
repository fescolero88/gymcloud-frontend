define [
  'views/trainer/clients/clients-view' #ClientsView
  'views/trainer/clients/client-list-view' #ClientListView
  'views/trainer/clients/group-list-view' #GroupListView
  'models/client' #Client
  'models/user' #User
  'collections/clients' #Clients
  'collections/activities' #Activities
  'features/profile/view' #ProfileView
  'models/client_group' #ClientGroup
  'collections/client_groups' #ClientGroups
  'features/client_groups/show/view' #ClientGroupView
  'views/trainer/global_ewp/ewp-global-view' #EWPGlobalView
  'features/exercises/constructor/view' #ExerciseConstructorView
  'models/exercise' #Exercise
  'models/global_workout' #GlobalWorkout
  'views/trainer/programs/program_global_view' #ProgramGlobalView
  'models/global_program' #GlobalProgram
  'features/properties/view' #PropertiesView
  'features/workouts/constructor/view' #WorkoutConstructorView
  'features/programs/constructor/view' #ProgramConstructorView
  'features/folders/view' #FoldersView
],
(
  ClientsView
  ClientListView
  GroupListView
  Client
  User
  Clients
  Activities
  ProfileView
  ClientGroup
  ClientGroups
  ClientGroupView
  EWPGlobalView
  ExerciseConstructorView
  Exercise
  GlobalWorkout
  ProgramGlobalView
  GlobalProgram
  PropertiesView
  WorkoutConstructorView
  ProgramConstructorView
  FoldersView
) ->

  class TrainerController extends Marionette.Controller

    queueMethod: false

    queue: ->
      if @queueMethod
        if App.request('auth:isAuthorizedAs', 'trainer')
          @[@queueMethod].apply(null, @queueArgs)
          @queueMethod = false
          @queueArgs = null

    initialize: (options) ->
      App.vent.on 'assignments:loaded', =>
        @queue()
        if @globalViewMethod
          @[@globalViewMethod](@globalType, @globalKey)
          @globalViewMethod = false

    myProfile: ->
      currentUser = App.request('current_user')
      @_userProfile(currentUser)

    profile: (id) ->
      currentUser = App.request('current_user')
      user = currentUser.clients.get(id)
      if user
        @_userProfile(user)
      else
        user = new User(id: id)
        user.fetch().then =>
          @_userProfile(user)

    _userProfile: (user) ->
      view = new ProfileView
        model: user
      @mainView.content.show(view)

    clientGroupShow: (id) ->
      user = App.request('current_user')
      clientGroup = user.client_groups.get(id)

      view = new ClientGroupView
        itemModel: clientGroup
        model: clientGroup
        itemId: id
      @mainView.content.show(view)

    clients: (viewType) ->
      profileModel = App.request 'current_user'
      uid = App.request('current_user_id')
      if uid
        @renderClientList(uid)
      else
        @listenToOnce profileModel, 'sync', =>
          @renderClientList(uid, viewType)

    renderClientList: (uid, viewType) ->
      clientsPageView = new ClientsView viewType: viewType
      @mainView.content.show clientsPageView

      clients = new Clients
      clients.url = "#{clients.url}/#{uid}/collections/clients"
      clientGroups = new ClientGroups
      clientGroups.url = "#{clientGroups.url}/#{uid}/collections/client_groups"
      clientsView = new ClientListView
        collection: clients
      groupsView = new GroupListView
        collection: clientGroups

      if viewType is 'individuals'
        @initializeSplashListeners(clients, clientsPageView, viewType)
        clients.fetch()
        clientsPageView.clients.show(clientsView)
      else if viewType is 'groups'
        @initializeSplashListeners(clientGroups, clientsPageView, viewType)
        clientGroups.fetch()
        clientsPageView.groups.show(groupsView)
      else
        clientsPageView.clients.show(clientsView)
        clientsPageView.groups.show(groupsView)

        $.when(clients.fetch(), clientGroups.fetch())
          .then (clientData, groupData) ->
            # if no data is present on both individual and group show splash
            if clientData[0].length is 0 and groupData[0].length is 0
              clientsPageView.ui.splash.removeClass 'hidden'
              clientsPageView.clients.$el.addClass 'hidden'
              clientsPageView.groups.$el.addClass 'hidden'

      clientsPageView.initRegionListeners()

    clientOrGroup: (type, id, assign, key) ->
      currentViewName = @mainView.content.currentView?.constructor.name
      if currentViewName is 'ClientGroupView'
        @mainView.content.currentView.trigger 'load:view', assign, key
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
          itemModel.url = "/api/mobile/me"
        itemModel.fetch()

        recentActivity = new Activities
        if id > 0
          if type is 'clients'
            recentActivity.url = "/api/mobile/clients/#{id}/notifications"
          else
            recentActivity.url = "/api/mobile/client_groups/#{id}/notifications"
        else
          recentActivity.url = "/api/mobile/notifications"
        recentActivity.loadMore()

        itemPageView = new ClientGroupView
          itemModel: itemModel
          recentActivity: recentActivity
          itemId: id
          assign: assign
          key: key
          viewType: type
        @mainView.content.show itemPageView

    client: (id, assign, key) ->
      @clientOrGroup 'clients', id, assign, key

    group: (id, assign, key) ->
      @clientOrGroup 'client_groups', id, assign, key

    me: (assign, key) ->
      assign = assign || 'exercises'
      @clientOrGroup 'clients', 0, assign, key

    properties: ->
      propertiesPageView = new PropertiesView
      @mainView.content.show(propertiesPageView)

    exerciseConstructor: (id) ->
      collection = App.request('current_user').exercises
      model = collection.get(id) || new Exercise
      view = new ExerciseConstructorView(model: model)
      if model.isNew()
        model.fetch(id: id).then =>
          @mainView.content.show(view)
      else
        @mainView.content.show(view)

    workoutConstructor: (id) ->
      @_entityConstructor('workout', id)

    programConstructor: (id) ->
      @_entityConstructor('program', id)

    _entityConstructor: (type, id) ->
      currentUser = App.request('current_user')
      collection = currentUser["#{type}_templates"]
      model = collection.get(id)
      breadcrumbs = [{title: type}]

      View = {
        workout: WorkoutConstructorView
        program: ProgramConstructorView
      }[type]

      view = new View(model: model, breadcrumbs: breadcrumbs)
      @mainView.content.show(view)

    exercisesFolderView: (folder_id) ->
      @_entityFolderView('exercises', folder_id)

    workoutTemplatesFolderView: (folder_id) ->
      @_entityFolderView('workout_templates', folder_id)

    programTemplatesFolderView: (folder_id) ->
      @_entityFolderView('program_templates', folder_id)

    _entityFolderView: (type, folder_id) ->
      user = App.request('current_user')
      folder_id ||= user.library.first().id
      folders = user.folders
      folder = folders.get(folder_id)
      view = new FoldersView
        model: folder
        items: folder.items
        type: type
      @mainView.content.show(view)

    searchInLibrary: (items, key, breadcrumbs) ->
      filtered = items.where({key: parseInt(key)})
      if filtered.length
        result = filtered[0]
        breadcrumbs.push({title: result.get('title')})
      else
        items.each (item) =>
          if item.has('items')
            searchResults = @searchInLibrary(
              new Backbone.Collection(item.get('items')),
              key,
              [{title: item.get 'title'}]
            )
            if searchResults.model
              result = searchResults.model
              breadcrumbs = breadcrumbs.concat searchResults.path
      return {model: result, path: breadcrumbs}

    initializeSplashListeners: (collection, view, viewType) ->
      if viewType is 'individuals' or viewType is 'groups'
        regionName = if viewType is 'individuals' then 'clients' else 'groups'
        viewTypeUI = view.ui["#{regionName}Region"]

        collection.on 'sync', (col) ->
          if col.length is 0
            view.ui.splash.removeClass 'hidden'
            viewTypeUI.addClass 'hidden'
