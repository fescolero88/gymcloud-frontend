Marionette = require 'backbone.marionette'
myTemplate = require '../../../templates/trainer/calendar/calendar-week'

module.exports = class CalendarWeekView extends Marionette.ItemView

  initialize: =>
    @template = myTemplate
