CustomRouter  = require 'routers/general/custom-router'

module.exports = class ClientRouter extends CustomRouter

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

  before: (methodName) =>
    App.request 'auth:isAuthorized', 'client'
    App.vent.trigger 'module:main-client:beforeAction'
