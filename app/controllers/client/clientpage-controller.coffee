Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ClientPageView = require 'views/client/clientpage-view'
ClientPageSidebarView = require 'views/client/clientpage-sidebar-view'
ClientPageNavView = require 'views/client/clientpage-nav-view'

ExercisesView = require 'views/client/clientpage-exercises-view'
WorkoutsView = require 'views/client/clientpage-workouts-view'
ProgramsView = require 'views/client/clientpage-programs-view'

ExercisesCollection = require 'models/trainer/exercises-collection'
WorkoutsCollection = require 'models/trainer/workouts-collection'
ProgramsCollection = require 'models/trainer/programs-collection'

CalendarDayView = require 'views/client/clientpage-calendar-day-view'
CalendarWeekView = require 'views/client/clientpage-calendar-week-view'
CalendarMonthView = require 'views/client/clientpage-calendar-month-view'

MessagesView = require 'views/general/messages/messages-view'

module.exports = class ClientPageController extends Marionette.Controller

  initialize: (options) =>
    @mainView = options.mainView
    @userPageView = null

  beforeAction: () =>
    if not @userPageView or !@userPageView.content
      @userPageView = new ClientPageView()
      @mainView.content.show @userPageView

      @navView = new ClientPageNavView()
      @userPageView.nav.show @navView

  clientPageExercises: (id) =>
    @beforeAction()

    exercisesCollection = new ExercisesCollection
    exercisesCollection.url = "/api/mobile/me/exercises"
    exercisesCollection.fetch()
    contentView = new ExercisesView collection: exercisesCollection
    @userPageView.content.show contentView

    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-e'

  clientPageWorkouts: (id) =>
    @beforeAction()

    workoutsCollection = new WorkoutsCollection
    workoutsCollection.url = "/api/mobile/me/workouts"
    workoutsCollection.fetch()
    contentView = new WorkoutsView collection: workoutsCollection
    @userPageView.content.show contentView

    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-w'

  clientPagePrograms: (id) =>
    @beforeAction()

    programsCollection = new ProgramsCollection
    programsCollection.url = "/api/mobile/me/programs"
    programsCollection.fetch()
    contentView = new ProgramsView collection: programsCollection
    @userPageView.content.show contentView

    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-p'

  clientPageCalendarDay: (id) =>
    @beforeAction()

    contentView = new CalendarDayView()
    @userPageView.content.show contentView

    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-c'

  clientPageCalendarWeek: (id) =>
    @beforeAction()

    contentView = new CalendarWeekView()
    @userPageView.content.show contentView

    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-c'

  clientPageCalendarMonth: (id) =>
    @beforeAction()

    contentView = new CalendarMonthView()
    @userPageView.content.show contentView

    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-c'

