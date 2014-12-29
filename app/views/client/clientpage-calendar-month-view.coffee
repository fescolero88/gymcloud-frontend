Marionette = require 'backbone.marionette'

module.exports = class CalendarMonthView extends Marionette.ItemView
  template: Templates.client.calendar.calendar_month
