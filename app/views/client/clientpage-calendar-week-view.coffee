Marionette = require 'backbone.marionette'
myTemplate = require '../../templates/client/calendar/calendar-week'

module.exports = class CalendarWeekView extends Marionette.ItemView
  template: myTemplate
