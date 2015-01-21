Marionette = require 'backbone.marionette'

module.exports = class ClientsRouter extends Marionette.AppRouter

  appRoutes:
    '': 'clients'
    'clients(/)(/:view_type)': 'clients'
    'clients/id/:id(/)': 'client'
    'clients/id/:id/:assign(/)': 'client'
    'clients/id/:id/:assign/:calendarType(/)': 'client'
    'groups/id/:id(/)': 'group'
    'groups/id/:id/:assign(/)': 'group'
    'groups/id/:id/:assign/:calendarType(/)': 'group'

    'properties(/)': 'properties'
