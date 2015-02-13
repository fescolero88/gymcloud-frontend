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

PropertiesView = require 'views/trainer/properties/properties-view'
PropertyListView = require 'views/trainer/properties/property-list-view'
PropertyModalView = require 'views/trainer/properties/property-modal-view'
PropertyModel = require 'models/trainer/property-model'
PropertyCollection = require 'models/trainer/property-collection'

module.exports = class TrainerController extends Marionette.Controller

  initialize: (options) =>
    @mainView = options.mainView

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
    recentActivity.fetch()

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
