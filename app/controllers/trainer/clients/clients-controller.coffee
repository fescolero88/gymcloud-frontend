Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ClientsView = require 'views/trainer/clients/clients-view'
ClientListView = require 'views/trainer/clients/client-list-view'
GroupListView = require 'views/trainer/clients/group-list-view'
GroupView = require 'views/trainer/groups/group-view'

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
    @client_page_view = null

  beforeAction: () =>
    if not @client_page_view or not @client_page_view.header
      @client_page_view = new ClientView()
      @mainView.content.show @client_page_view

      @nav_view = new ClientNavView()
      @client_page_view.nav.show @nav_view

  clients: (view_type) =>
    clients_page_view = new ClientsView view_type
    @mainView.content.show clients_page_view

    if view_type != 'groups'
      client_collection = new Backbone.Collection()
      client_collection.url = '/api/mobile/clients'
      client_collection.fetch()
      clients_view = new ClientListView collection: client_collection
      clients_page_view.clients.show clients_view

    if view_type != 'individuals'
      group_collection = new Backbone.Collection()
      group_collection.url = '/api/mobile/client_groups'
      group_collection.fetch()
      groups_view = new GroupListView collection: group_collection
      clients_page_view.groups.show groups_view

  client: (id) =>
    @beforeAction()

    headerView = new ClientHeaderView()
    @client_page_view.header.show headerView

    left_view = new ClientLeftView()
    @client_page_view.leftside.show left_view

    right_view = new ClientRightView()
    @client_page_view.rightside.show right_view

  clientCalendarDay: (id) =>
    @beforeAction()

    headerView = new ClientHeaderView()
    @client_page_view.header.show headerView

    left_view = new CalendarDayView()
    @client_page_view.leftside.show left_view

    right_view = new ClientRightView()
    @client_page_view.rightside.show right_view

  clientCalendarWeek: (id) =>
    @beforeAction()

    headerView = new ClientHeaderView()
    @client_page_view.header.show headerView

    left_view = new CalendarWeekView()
    @client_page_view.leftside.show left_view

    right_view = new ClientRightView()
    @client_page_view.rightside.show right_view

  clientCalendarMonth: (id) =>
    @beforeAction()

    headerView = new ClientHeaderView()
    @client_page_view.header.show headerView

    left_view = new CalendarMonthView()
    @client_page_view.leftside.show left_view

    right_view = new ClientRightView()
    @client_page_view.rightside.show right_view

  clientExercises: (id) =>
    @beforeAction()

    headerView = new ClientHeaderView()
    @client_page_view.header.show headerView

    left_view = new ExercisesView()
    @client_page_view.leftside.show left_view

    right_view = new ClientRightView()
    @client_page_view.rightside.show right_view

  clientExercise: (id) =>
    @beforeAction()

    headerView = new ClientCompactHeaderView()
    @client_page_view.header.show headerView

    left_view = new ExerciseView()
    @client_page_view.leftside.show left_view

    right_view = new PersonalBestView()
    @client_page_view.rightside.show right_view

  group: (id) =>
    @beforeAction()

    group_page_view = new GroupView()
    @mainView.content.show group_page_view

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

