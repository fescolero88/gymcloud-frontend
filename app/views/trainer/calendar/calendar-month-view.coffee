Marionette = require 'backbone.marionette'
myTemplate = require '../../../templates/trainer/calendar/calendar-month'

module.exports = class CalendarMonthView extends Marionette.ItemView

  initialize: =>
    @template = myTemplate
