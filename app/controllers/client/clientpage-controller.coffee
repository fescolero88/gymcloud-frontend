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
    @user_page_view = null

  beforeAction: () =>
    if not @user_page_view
      @user_page_view = new ClientPageView()
      @mainView.content.show @user_page_view

      @nav_view = new ClientPageNavView()
      @user_page_view.nav.show @nav_view

  clientPageExercises: (id) =>
    @beforeAction()

    content_view = new ExercisesView()
    @user_page_view.content.show content_view

    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-e'

  clientPageWorkouts: (id) =>
    @beforeAction()

    content_view = new WorkoutsView()
    @user_page_view.content.show content_view

    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-w'

  clientPagePrograms: (id) =>
    @beforeAction()

    content_view = new ProgramsView()
    @user_page_view.content.show content_view

    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-p'

  clientPageCalendarDay: (id) =>
    @beforeAction()

    content_view = new CalendarDayView()
    @user_page_view.content.show content_view

    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-c'

  clientPageCalendarWeek: (id) =>
    @beforeAction()

    content_view = new CalendarWeekView()
    @user_page_view.content.show content_view

    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-c'

  clientPageCalendarMonth: (id) =>
    @beforeAction()

    content_view = new CalendarMonthView()
    @user_page_view.content.show content_view

    App.vent.trigger 'clientpage:nav-click', '#gc-clientpage-nav-tab-c'

