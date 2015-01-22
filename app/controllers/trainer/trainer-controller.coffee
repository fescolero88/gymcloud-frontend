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
    if viewType is 'individuals'
      groupsView.$el.hide()

  clientOrGroup: (type, id, assign, calendarType) ->
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
      calendayType: calendarType
      viewType: type
    @mainView.content.show itemPageView

  client: (id, assign, calendarType) =>
    @clientOrGroup 'clients', id, assign, calendarType

  group: (id, assign, calendarType) =>
    @clientOrGroup 'client_groups', id, assign, calendarType

  properties: =>
    prop_collection = new Backbone.Collection [
      {
        'name': 'Weight (kg)'
        'default': 0
        'type': 'Numeric'
        'weight': 4
      }
      {
        'name': 'Distance'
        'default': 0
        'type': 'Numeric'
        'weight': 2
      }
      {
        'name': 'Sets'
        'default': 'None'
        'type': 'String'
        'weight': 1
      }
      {
        'name': 'Reps'
        'default': 0
        'type': 'Numeric'
        'weight': 3
      }
    ]
    properties_page_view = new PropertiesView collection: prop_collection
    properties_page_view.collection.comparator = (model) -> model.get('weight')
    properties_page_view.collection.sort()

    @mainView.content.show properties_page_view

    $('.gc-properties-list').sortable
      handle: '.draggable-handle'
      placeholder: '<li class="placeholder sortable-placeholder"/>'
      onDrop: ($item) =>
        $item.removeClass("dragged").removeAttr("style")
        $("body").removeClass("dragging")
        properties_page_view.resort()
