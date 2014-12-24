Marionette = require 'backbone.marionette'

module.exports = class CalendarWeekView extends Marionette.ItemView

  initialize: =>
    @template = require '../../../templates/trainer/calendar/calendar-week'

