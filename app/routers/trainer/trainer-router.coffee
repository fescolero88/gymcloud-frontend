Marionette = require 'backbone.marionette'

module.exports = class TrainerRouter extends Marionette.AppRouter
  processAppRoutes: (routeName, routeArgs) ->
    console.log App.request('auth:isAuthorized', 'trainer')
    return unless App.request('auth:isAuthorized', 'trainer')
    super

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
