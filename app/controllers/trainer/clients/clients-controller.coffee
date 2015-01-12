Marionette = require 'backbone.marionette'

ClientsView = require 'views/trainer/clients/clients-view'
ClientListView = require 'views/trainer/clients/client-list-view'
GroupListView = require 'views/trainer/clients/group-list-view'
GroupView = require 'views/trainer/groups/group-view'

ClientModel = require 'models/trainer/client-model'
ClientCollection = require 'models/trainer/client-collection'
GroupModel = require 'models/trainer/group-model'
GroupCollection = require 'models/trainer/group-collection'

ClientView = require 'views/trainer/clients/client-view'
ClientHeaderView = require 'views/trainer/clients/client-header-view'
ClientNavView = require 'views/trainer/clients/client-nav-view'
ClientCompactHeaderView = require 'views/trainer/clients/client-compact-header-view'
ClientLeftView = require 'views/trainer/clients/client-left-view'
ClientRightView = require 'views/trainer/clients/client-right-view'

ExercisesView = require 'views/trainer/exercises/exercises-view'
ExerciseView = require 'views/trainer/exercises/exercise-view'
PersonalBestView = require 'views/trainer/exercises/personal-best-view'

CalendarDayView = require 'views/trainer/calendar/calendar-day-view'
CalendarWeekView = require 'views/trainer/calendar/calendar-week-view'
CalendarMonthView = require 'views/trainer/calendar/calendar-month-view'

PropertiesView = require 'views/trainer/properties/properties-view'

MessagesView = require 'views/general/messages/messages-view'

module.exports = class ClientsController extends Marionette.Controller

  initialize: (options) =>
    @mainView = options.mainView
    @clientPageView = null

  beforeAction: () =>
    if not @clientPageView or not @clientPageView.header
      @clientPageView = new ClientView()
      @mainView.content.show @clientPageView

      @navView = new ClientNavView()
      @clientPageView.nav.show @navView

  clients: (view_type) =>
    clientsPageView = new ClientsView view_type
    @mainView.content.show clientsPageView

    if view_type != 'groups'
      clientCollection = new ClientCollection
      clientCollection.fetch()
      clientsView = new ClientListView collection: clientCollection
      clientsPageView.clients.show clientsView

    groupCollection = new GroupCollection
    groupCollection.fetch()
    groupsView = new GroupListView collection: groupCollection
    clientsPageView.groups.show groupsView
    if view_type is 'individuals'
      groupsView.$el.hide()

  client: (id) =>
    @beforeAction()

    headerView = new ClientHeaderView()
    @clientPageView.header.show headerView

    leftView = new ClientLeftView()
    @clientPageView.leftside.show leftView

    rightView = new ClientRightView()
    @clientPageView.rightside.show rightView

  clientCalendarDay: (id) =>
    @beforeAction()

    headerView = new ClientHeaderView()
    @clientPageView.header.show headerView

    leftView = new CalendarDayView()
    @clientPageView.leftside.show leftView

    rightView = new ClientRightView()
    @clientPageView.rightside.show rightView

  clientCalendarWeek: (id) =>
    @beforeAction()

    headerView = new ClientHeaderView()
    @clientPageView.header.show headerView

    leftView = new CalendarWeekView()
    @clientPageView.leftside.show leftView

    rightView = new ClientRightView()
    @clientPageView.rightside.show rightView

  clientCalendarMonth: (id) =>
    @beforeAction()

    headerView = new ClientHeaderView()
    @clientPageView.header.show headerView

    leftView = new CalendarMonthView()
    @clientPageView.leftside.show leftView

    rightView = new ClientRightView()
    @clientPageView.rightside.show rightView

  clientExercises: (id) =>
    @beforeAction()

    clientModel = new ClientModel
    clientModel.url = "/api/mobile/clients/#{id}"
    clientModel.fetch()

    headerView = new ClientHeaderView model: clientModel
    @clientPageView.header.show headerView

    leftView = new ExercisesView()
    @clientPageView.leftside.show leftView

    rightView = new ClientRightView()
    @clientPageView.rightside.show rightView

  clientExercise: (id) =>
    @beforeAction()

    headerView = new ClientCompactHeaderView()
    @clientPageView.header.show headerView

    leftView = new ExerciseView()
    @clientPageView.leftside.show leftView

    rightView = new PersonalBestView()
    @clientPageView.rightside.show rightView

  group: (id) =>
    @beforeAction()

    groupModel = new GroupModel
    groupModel.url = "/api/mobile/client_groups/#{id}"
    groupModel.fetch()

    groupPageView = new GroupView model: groupModel
    @mainView.content.show groupPageView

  properties: =>
    @beforeAction()

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
