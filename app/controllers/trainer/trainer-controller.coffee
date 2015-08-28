Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ClientsView = require 'views/trainer/clients/clients-view'
ClientListView = require 'views/trainer/clients/client-list-view'
GroupListView = require 'views/trainer/clients/group-list-view'

Client = require 'models/client'
Clients = require 'collections/clients'
Activities = require 'collections/activities'
ClientGroup = require 'models/client_group'
ClientGroups = require 'collections/client_groups'

ClientGroupView = require 'views/trainer/clients/client-group-view'

EWPGlobalView = require 'views/trainer/global_ewp/ewp-global-view'

ExerciseGlobalView = require 'views/trainer/exercises/exercise_global_view'
GlobalExercise = require 'models/global_exercise'

WorkoutGlobalView = require 'views/trainer/workouts/workout_global_view'
GlobalWorkout = require 'models/global_workout'

ProgramGlobalView = require 'views/trainer/programs/program_global_view'
GlobalProgram = require 'models/global_program'

PropertiesView = require 'views/trainer/properties/properties-view'

module.exports = class TrainerController extends Marionette.Controller
  queueMethod: false

  queue: =>
    if @queueMethod
      if App.request('auth:isAuthorizedAs', 'trainer')
        @[@queueMethod].apply(null, @queueArgs)
        @queueMethod = false
        @queueArgs = null

  initialize: (options) =>
    App.vent.on 'assignments:loaded', =>
      @queue()
      if @globalViewMethod
        @[@globalViewMethod](@globalType, @globalKey)
        @globalViewMethod = false

  clients: (viewType) =>
    clientsPageView = new ClientsView viewType: viewType
    @mainView.content.show clientsPageView

    clientCollection = new Clients
    groupCollection = new ClientGroups
    clientsView = new ClientListView collection: clientCollection
    groupsView = new GroupListView collection: groupCollection

    if viewType is 'individuals'
      @initializeSplashListeners clientCollection, clientsPageView, viewType
      clientCollection.fetch()
      clientsPageView.clients.show clientsView
    else if viewType is 'groups'
      @initializeSplashListeners groupCollection, clientsPageView, viewType
      groupCollection.fetch()
      clientsPageView.groups.show groupsView
    else # show both
      clientsPageView.clients.show clientsView
      clientsPageView.groups.show groupsView

      $.when(clientCollection.fetch(), groupCollection.fetch()).then (clientData, groupData) =>
        # if no data is present on both individual and group show splash
        if clientData[0].length == 0 and groupData[0].length == 0
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

  client: (id, assign, key) =>
    @clientOrGroup 'clients', id, assign, key

  group: (id, assign, key) =>
    @clientOrGroup 'client_groups', id, assign, key

  me: (assign, key) =>
    assign = assign || 'exercises'
    @clientOrGroup 'clients', 0, assign, key

  properties: =>
    propertyCollection = new Properties
    propertyCollection.fetch()
    propertyListView = new PropertyListView collection: propertyCollection

    propertiesPageView = new PropertiesView
      collection: propertyCollection
      listView: propertyListView
    @mainView.content.show propertiesPageView

    propertyModel = new Property
    propertyModalView = new PropertyModalView model: propertyModel
    propertiesPageView.propertyModalView.show propertyModalView

  propertiesView: =>
    propertiesPageView = new PropertiesView
    @mainView.content.show(propertiesPageView)

  globalView: (type, key) =>
    items = App.request("data:#{type}")
    if items?
      breadcrumbs = [{title:"#{type}"}]
      if key
        searchResults = @searchInLibrary(new Backbone.Collection(items), key, breadcrumbs)
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
              exerciseGlobalView = new ExerciseGlobalView(exercise: model, breadcrumbs: breadcrumbs)
              @mainView.content.show exerciseGlobalView
          when 'workouts'
            model = new GlobalWorkout
            model.url = model.urlRoot + key
            model.fetch().then =>
              workoutGlobalView = new WorkoutGlobalView(workout: model, breadcrumbs: breadcrumbs)
              @mainView.content.show workoutGlobalView
          when 'programs'
            model = new GlobalProgram
            model.url = model.urlRoot + key
            model.fetch().then =>
              programGlobalView = new ProgramGlobalView(model: model, breadcrumbs: breadcrumbs)
              @mainView.content.show programGlobalView
    else
      @queueMethod = 'globalView'
      @queueArgs = arguments

  searchInLibrary: (items, key, breadcrumbs) =>
    filtered = items.where({key: parseInt(key)})
    if filtered.length
      result = filtered[0]
      breadcrumbs.push({title: result.get('title')})
    else
      items.each (item) =>
        if item.has('items')
          searchResults = @searchInLibrary(new Backbone.Collection(item.get('items')), key, [{title: item.get 'title'}])
          if searchResults.model
            result = searchResults.model
            breadcrumbs = breadcrumbs.concat searchResults.path
    return {model: result, path: breadcrumbs}

  initializeSplashListeners: (collection, view, viewType) =>
    regionName = null
    if viewType == 'individuals' or viewType == 'groups'
      regionName = if viewType == 'individuals' then 'clients' else 'groups'
      viewTypeUI = view.ui["#{regionName}Region"]

      collection.on 'sync', (col) =>
        if col.length == 0
          view.ui.splash.removeClass 'hidden'
          viewTypeUI.addClass 'hidden'
