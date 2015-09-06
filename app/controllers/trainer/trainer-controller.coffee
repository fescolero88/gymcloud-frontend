define [
  'backbone.marionette'
  'backbone'
  'views/trainer/clients/clients-view'
  'views/trainer/clients/client-list-view'
  'views/trainer/clients/group-list-view'
  'models/client'
  'collections/clients'
  'collections/activities'
  'features/profile/view'
  'models/client_group'
  'collections/client_groups'
  'views/trainer/clients/client-group-view'
  'views/trainer/global_ewp/ewp-global-view'
  'views/trainer/exercises/exercise_global_view'
  'models/global_exercise'
  'views/trainer/workouts/workout_global_view'
  'models/global_workout'
  'views/trainer/programs/program_global_view'
  'models/global_program'
  'features/properties/view'
  'features/workouts/constructor/view'
],
(
  Marionette
  Backbone
  ClientsView
  ClientListView
  GroupListView
  Client
  Clients
  Activities
  ProfileView
  ClientGroup
  ClientGroups
  ClientGroupView
  EWPGlobalView
  ExerciseGlobalView
  GlobalExercise
  WorkoutGlobalView
  GlobalWorkout
  ProgramGlobalView
  GlobalProgram
  PropertiesView
  WorkoutConstructorView
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

    profile: (assign, key) ->
      view = new ProfileView
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

    workoutConstructor: (id) ->
      currentUser = App.request('current_user')
      collection = currentUser.workout_templates

      model = collection.get(id)
      breadcrumbs = [{title:"workout"}]

      view = new WorkoutConstructorView
        model: model
        breadcrumbs: breadcrumbs
      @mainView.content.show(view)

    globalView: (type, key) ->
      items = App.request("data:#{type}")
      if items?
        breadcrumbs = [{title:"#{type}"}]
        if key
          searchResults = @searchInLibrary(
            new Backbone.Collection(items),
            key,
            breadcrumbs
          )
          childModel = searchResults.model
          breadcrumbs = searchResults.path
          items = if childModel then childModel.get('items') else []
        else
          childModel = new Backbone.Model
        if childModel and childModel.get('isFolder') or not key
          exercisesGlobalView = new EWPGlobalView
            model: childModel
            items: items
            breadcrumbs: breadcrumbs
            type: type
          @mainView.content.show exercisesGlobalView
        else
          switch type
            when 'exercises'
              model = new GlobalExercise
              model.url = model.urlRoot + key
              model.fetch().then =>
                view = new ExerciseGlobalView
                  exercise: model
                  breadcrumbs: breadcrumbs
                @mainView.content.show(view)
            when 'workouts'
              model = new GlobalWorkout
              model.url = model.urlRoot + key
              model.fetch().then =>
                view = new WorkoutGlobalView
                  workout: model
                  breadcrumbs: breadcrumbs
                @mainView.content.show(view)
            when 'programs'
              model = new GlobalProgram
              model.url = model.urlRoot + key
              model.fetch().then =>
                view = new ProgramGlobalView
                  model: model
                  breadcrumbs: breadcrumbs
                @mainView.content.show(view)
      else
        @queueMethod = 'globalView'
        @queueArgs = arguments

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