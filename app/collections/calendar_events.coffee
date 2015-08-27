define [
  'backbone'
], (
  Backbone
) ->

  class CalendarEvents extends Backbone.Collection

    url: '/api/mobile/calendar/'
