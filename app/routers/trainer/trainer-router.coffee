CustomRouter  = require 'routers/general/custom-router'

module.exports = class TrainerRouter extends CustomRouter

  appRoutes:
    '': 'root'
    'welcome' : 'stats'
    'tr(/)': 'clients'
    'tr/clients(/)(/:view_type)': 'clients'
    'tr/clients/id/:id/:assign(/)': 'client'
    'tr/clients/id/:id/:assign/:key(/)': 'client'
    'tr/groups/id/:id/:assign(/)': 'group'
    'tr/groups/id/:id/:assign/:key(/)': 'group'

    'tr/me(/)': 'profile'
    'tr/me/:assign(/)': 'me'
    'tr/me/:assign/:key(/)': 'me'

    'users/me(/)': 'myProfile'
    'users/me/edit': 'editMyProfile'
    'users/:id(/)': 'profile'
    'client_groups/:id(/)': 'clientGroupShow'
    'properties(/)': 'properties'

    'exercises_folder(/:id)(/)': 'exercisesFolderView'
    'workout_templates_folder(/:id)(/)': 'workoutTemplatesFolderView'
    'program_templates_folder(/:id)(/)': 'programTemplatesFolderView'

    'exercises/:id(/)': 'exerciseConstructor'
    'workout_templates/:id(/)': 'workoutConstructor'
    'program_templates/:id(/)': 'programConstructor'

  before: (methodName) ->
    App.request 'auth:isAuthorizedAs', 'trainer'
    App.vent.trigger 'module:main-trainer:beforeAction'
    $('html, body').animate { scrollTop: 0 }, 'fast'
