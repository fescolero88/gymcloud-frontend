Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ClientsView = require 'views/trainer/clients/clients-view'
ClientListView = require 'views/trainer/clients/client-list-view'
GroupListView = require 'views/trainer/clients/group-list-view'

ClientModel = require 'models/trainer/client-model'
ClientCollection = require 'models/trainer/client-collection'
ActivityCollection = require 'models/trainer/activity-collection'
GroupModel = require 'models/trainer/group-model'
GroupCollection = require 'models/trainer/group-collection'

ClientGroupView = require 'views/trainer/clients/client-group-view'

ExercisesGlobalView = require 'views/trainer/exercises/exercises-global-view'
ExerciseGlobalView = require 'views/trainer/exercises/exercise-global-view'
GlobalExerciseModel = require 'models/trainer/global-exercise-model'

PropertiesView = require 'views/trainer/properties/properties-view'
PropertyListView = require 'views/trainer/properties/property-list-view'
PropertyModalView = require 'views/trainer/properties/property-modal-view'
PropertyModel = require 'models/trainer/property-model'
PropertyCollection = require 'models/trainer/property-collection'

module.exports = class TrainerController extends Marionette.Controller
  exercisesMethod: false

  initialize: (options) =>
    @mainView = options.mainView
    App.vent.on 'assignments:loaded', =>
      if @exercisesMethod
        @[@exercisesMethod](@exerciseKey)
        @exercisesMethod = false

  clients: (viewType) =>
    clientsPageView = new ClientsView viewType
    @mainView.content.show clientsPageView

    if viewType != 'groups'
      clientCollection = new ClientCollection
      clientCollection.fetch()
      clientsView = new ClientListView collection: clientCollection
      clientsPageView.clients.show clientsView

    groupCollection = new GroupCollection
    groupCollection.fetch()
    groupsView = new GroupListView collection: groupCollection
    clientsPageView.groups.show groupsView

    clientsPageView.initRegionListeners()

    if viewType is 'individuals'
      groupsView.$el.hide()

  clientOrGroup: (type, id, assign, key) ->
    currentViewName = @mainView.content.currentView?.constructor.name
    if currentViewName is 'ClientGroupView'
      @mainView.content.currentView.trigger 'load:view', assign, key
    else
      if type is 'clients'
        itemModel = new ClientModel
        itemModel.url = "/api/mobile/clients/#{id}"
      else
        itemModel = new GroupModel
        itemModel.url = "/api/mobile/client_groups/#{id}"
      itemModel.fetch()

      recentActivity = new ActivityCollection
      if type is 'clients'
        recentActivity.url = "/api/mobile/clients/#{id}/notifications"
      else
        recentActivity.url = "/api/mobile/client_groups/#{id}/notifications"
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

  properties: =>
    propertyCollection = new PropertyCollection
    propertyCollection.fetch()
    propertyListView = new PropertyListView collection: propertyCollection

    propertiesPageView = new PropertiesView
      collection: propertyCollection
      listView: propertyListView
    @mainView.content.show propertiesPageView

    propertyModel = new PropertyModel
    propertyModalView = new PropertyModalView model: propertyModel
    propertiesPageView.propertyModalView.show propertyModalView

  exercises: (key) =>
    @exerciseKey = key
    items = App.request('data:exercises')
    if items?
      breadcrumbs = ['Exercises']
      if @exerciseKey
        searchResults = @searchInLibrary(new Backbone.Collection(items), @exerciseKey, breadcrumbs)
        childModel = searchResults.model
        breadcrumbs = searchResults.path
        items = childModel.get('items')
      else
        childModel = new Backbone.Model
      if childModel.get('isFolder') or not @exerciseKey
        exercisesGlobalView = new ExercisesGlobalView(model: childModel, items: items, breadcrumbs: breadcrumbs)
        @mainView.content.show exercisesGlobalView
      else
        model = new GlobalExerciseModel
        model.url = model.urlRoot + @exerciseKey
        model.fetch().then =>
          exerciseGlobalView = new ExerciseGlobalView(model: model, breadcrumbs: breadcrumbs)
          @mainView.content.show exerciseGlobalView
    else
      @exercisesMethod = 'exercises'

  searchInLibrary: (items, key, breadcrumbs) =>
    filtered = items.where({key: parseInt(key)})
    if filtered.length
      result = filtered[0]
      breadcrumbs.push(result.get 'title')
    else
      items.each (item) =>
        if item.has('items')
          searchResults = @searchInLibrary(new Backbone.Collection(item.get('items')), key, [item.get 'title'])
          if searchResults.model
            result = searchResults.model
            breadcrumbs = breadcrumbs.concat searchResults.path
    return {model: result, path: breadcrumbs}
