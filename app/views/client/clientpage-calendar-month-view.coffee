Marionette = require 'backbone.marionette'
myTemplate = require '../../templates/client/calendar/calendar-month'

module.exports = class CalendarMonthView extends Marionette.ItemView
  template: myTemplate
