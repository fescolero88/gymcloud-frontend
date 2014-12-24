Marionette = require 'backbone.marionette'

module.exports = class CalendarMonthView extends Marionette.ItemView

  initialize: =>
    @template = require '../../../templates/trainer/calendar/calendar-month'

