Backbone = require 'backbone'

module.exports = class CalendarEventCollection extends Backbone.Collection

  url: '/api/mobile/calendar/'
