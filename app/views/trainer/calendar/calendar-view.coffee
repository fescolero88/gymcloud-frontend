Marionette = require 'backbone.marionette'

CalendarDayView = require 'views/trainer/calendar/calendar-day-view'
CalendarWeekView = require 'views/trainer/calendar/calendar-week-view'
CalendarMonthView = require 'views/trainer/calendar/calendar-month-view'

CalendarEventCollection = require 'models/trainer/calendar-event-collection'

module.exports = class CalendarView extends Marionette.LayoutView

  template: require('templates/trainer/calendar/calendar')

  events:
    'click @ui.calendarNav': 'navLinkClick'
    'click .gc-content-nav-back a': 'navBack'

  ui:
    calendarNav: '.calendar-nav'

  regions:
    calendar: '#calendar-content'

  navLinkClick: (ev) ->
    ev.preventDefault()
    @ui.calendarNav.removeClass('active')
    @$el.find(ev.currentTarget).addClass('active')
    navView = @$el.find(ev.currentTarget).data('nav-view')
    @loadCalendarView navView

  initialize: ->
    @currentDate = moment()
    @calendarEventCollection = new CalendarEventCollection
    @calendar_url = @calendarEventCollection.url

    year = @currentDate.year()
    month = @currentDate.month()+1
    @getData year, month

  getData: (year, month) ->
    @calendarEventCollection.url = "#{@calendar_url}?year=#{year}&month=#{month}"
    @calendarEventCollection.fetch()

  onShow: =>
    @loadCalendarView 'day'

  loadCalendarView: (navView) =>
    switch navView
      when 'day'
        @calendarView = new CalendarDayView
      when 'week'
        @calendarView = new CalendarWeekView
      when 'month'
        @calendarView = new CalendarMonthView
    @calendar.show @calendarView
