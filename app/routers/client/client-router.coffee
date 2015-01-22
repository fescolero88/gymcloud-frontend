Marionette = require 'backbone.marionette'

module.exports = class ClientRouter extends Marionette.AppRouter
  processAppRoutes: (routeName, routeArgs) ->
    return unless App.request('auth:isAuthorized')
    super

  appRoutes:
    '': 'clientPageExercises'
    '(/)': 'clientPageExercises'
    'exercises(/)': 'clientPageExercises'
    'workouts(/)': 'clientPageWorkouts'
    'programs(/)': 'clientPagePrograms'
    'calendar(/)': 'clientPageCalendarDay'
    'calendar/day/:day(/)': 'clientPageCalendarDay'
    'calendar/week/:week(/)': 'clientPageCalendarWeek'
    'calendar/month/:month(/)': 'clientPageCalendarMonth'
