Marionette = require 'backbone.marionette'

module.exports = class ClientsRouter extends Marionette.AppRouter

  appRoutes:
    '': 'clients'
    'clients(/)(/:view_type)': 'clients'
    'clients/id/:id(/)': 'clientExercises'
    'clients/id/:id/exercises(/)': 'clientExercises'
    'clients/id/:id/exercises/:exid(/)': 'clientExercise'
    'clients/id/:id/calendar(/)': 'clientCalendarDay'
    'clients/id/:id/calendar/month/:month(/)': 'clientCalendarMonth'
    'clients/id/:id/calendar/week/:week(/)': 'clientCalendarWeek'
    'clients/id/:id/calendar/day/:day(/)': 'clientCalendarDay'
    'groups/id/:id(/)': 'group'
    'properties(/)': 'properties'
