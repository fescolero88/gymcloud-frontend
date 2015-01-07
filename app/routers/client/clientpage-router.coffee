Marionette = require 'backbone.marionette'

module.exports = class ClientPageRouter extends Marionette.AppRouter

  appRoutes:
    '': 'clientPageExercises'
    'user/id/:id(/)': 'clientPageExercises'
    'user/id/:id/exercises(/)': 'clientPageExercises'
    'user/id/:id/workouts(/)': 'clientPageWorkouts'
    'user/id/:id/programs(/)': 'clientPagePrograms'
    'user/id/:id/calendar(/)': 'clientPageCalendarDay'
    'user/id/:id/calendar/day/:day(/)': 'clientPageCalendarDay'
    'user/id/:id/calendar/week/:week(/)': 'clientPageCalendarWeek'
    'user/id/:id/calendar/month/:month(/)': 'clientPageCalendarMonth'
