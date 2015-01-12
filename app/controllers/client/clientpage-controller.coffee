Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ClientPageView = require 'views/client/clientpage-view'
ClientPageSidebarView = require 'views/client/clientpage-sidebar-view'
ClientPageNavView = require 'views/client/clientpage-nav-view'

ExercisesView = require 'views/client/clientpage-exercises-view'
WorkoutsView = require 'views/client/clientpage-workouts-view'
ProgramsView = require 'views/client/clientpage-programs-view'

CalendarDayView = require 'views/client/clientpage-calendar-day-view'
CalendarWeekView = require 'views/client/clientpage-calendar-week-view'
CalendarMonthView = require 'views/client/clientpage-calendar-month-view'

MessagesView = require 'views/general/messages/messages-view'

module.exports = class ClientPageController extends Marionette.Controller

  initialize: (options) =>
    @mainView = options.mainView
    @userPageView = null

  beforeAction: () =>
    if not @userPageView
      @userPageView = new ClientPageView()
      @mainView.content.show @userPageView

      @navView = new ClientPageNavView()
      @userPageView.nav.show @navView

  clientPageExercises: (id) =>
    @beforeAction()

    contentView = new ExercisesView()
    @userPageView.content.show contentView

    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-e'

  clientPageWorkouts: (id) =>
    @beforeAction()

    contentView = new WorkoutsView()
    @userPageView.content.show contentView

    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-w'

  clientPagePrograms: (id) =>
    @beforeAction()

    contentView = new ProgramsView()
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

