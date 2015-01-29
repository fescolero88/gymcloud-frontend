CustomRouter  = require 'routers/general/custom-router'

module.exports = class TrainerRouter extends CustomRouter
  appRoutes:
    'tr(/)': 'clients'
    'tr/clients(/)(/:view_type)': 'clients'
    'tr/clients/id/:id(/)': 'client'
    'tr/clients/id/:id/:assign(/)': 'client'
    'tr/clients/id/:id/:assign/:calendarType(/)': 'client'
    'tr/groups/id/:id(/)': 'group'
    'tr/groups/id/:id/:assign(/)': 'group'
    'tr/groups/id/:id/:assign/:calendarType(/)': 'group'

    'tr/properties(/)': 'properties'

  before: (methodName)=>
    App.request 'auth:isAuthorized', 'trainer'
    App.vent.trigger 'module:main-trainer:beforeAction'
