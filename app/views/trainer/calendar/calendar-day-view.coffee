Marionette = require 'backbone.marionette'

module.exports = class CalendarDayView extends Marionette.ItemView

  initialize: =>
    @template = require '../../../templates/trainer/calendar/calendar-day'

