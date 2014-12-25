Marionette = require 'backbone.marionette'
myTemplate = require '../../templates/client/calendar/calendar-day'

module.exports = class CalendarDayView extends Marionette.ItemView
  template: myTemplate
