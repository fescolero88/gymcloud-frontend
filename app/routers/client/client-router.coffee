Marionette = require 'backbone.marionette'

module.exports = class ClientRouter extends Marionette.AppRouter
  processAppRoutes: (routeName, routeArgs) ->
    App.vent.trigger 'App:check-auth'
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
