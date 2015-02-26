CustomRouter  = require 'routers/general/custom-router'

module.exports = class TrainerRouter extends CustomRouter
  appRoutes:
    'tr(/)': 'clients'
    'tr/clients(/)(/:view_type)': 'clients'
    'tr/clients/id/:id/:assign(/)': 'client'
    'tr/clients/id/:id/:assign/:key(/)': 'client'
    'tr/groups/id/:id/:assign(/)': 'group'
    'tr/groups/id/:id/:assign/:key(/)': 'group'

    'tr/properties(/)': 'properties'
    'tr/exercises(/)': 'exercises'
    'tr/exercises/id/:id(/)': 'exercises'

  before: (methodName) =>
    App.request 'auth:isAuthorized', 'trainer'
    App.vent.trigger 'module:main-trainer:beforeAction'
