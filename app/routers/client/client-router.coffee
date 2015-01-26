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

  before: (methodName)=>
    App.vent.trigger 'module:main-client:beforeAction'
    App.request 'auth:isAuthorized', 'client'
