Marionette = require 'backbone.marionette'

module.exports = class CalendarWeekView extends Marionette.ItemView
  template: require '../../templates/client/calendar/calendar-week'
