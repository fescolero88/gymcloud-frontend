CustomRouter  = require 'routers/general/custom-router'

module.exports = class ClientRouter extends CustomRouter

  appRoutes:

    '': 'clientPageAssigments'
    '(/)': 'clientPageAssigments'
    'my/:dataType(/)': 'clientPageAssigments'
    'my/:dataType/:key(/)': 'clientPageAssigments'

    'calendar(/)': 'clientPageCalendarDay'
    'calendar/day/:day(/)': 'clientPageCalendarDay'
    'calendar/week/:week(/)': 'clientPageCalendarWeek'
    'calendar/month/:month(/)': 'clientPageCalendarMonth'

  before: (methodName) =>
    App.request 'auth:isAuthorizedAs', 'client'
    App.vent.on 'profile:ready', ->
      App.vent.trigger 'module:main-client:beforeAction'