Marionette = require 'backbone.marionette'

module.exports = class CalendarWeekView extends Marionette.ItemView
  template: Templates.client.calendar.calendar_week
