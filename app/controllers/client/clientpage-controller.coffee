Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ClientPageView = require '../../views/client/clientpage-view.coffee'
ClientPageSidebarView = require '../../views/client/clientpage-sidebar-view.coffee'
ClientPageNavView = require '../../views/client/clientpage-nav-view.coffee'

ExercisesView = require '../../views/client/clientpage-exercises-view.coffee'
WorkoutsView = require '../../views/client/clientpage-workouts-view.coffee'
ProgramsView = require '../../views/client/clientpage-programs-view.coffee'

CalendarDayView = require '../../views/client/clientpage-calendar-day-view.coffee'
CalendarWeekView = require '../../views/client/clientpage-calendar-week-view.coffee'
CalendarMonthView = require '../../views/client/clientpage-calendar-month-view.coffee'

MessagesView = require '../../views/general/messages/messages-view.coffee'

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
