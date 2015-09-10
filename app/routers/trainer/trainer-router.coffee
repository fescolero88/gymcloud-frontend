CustomRouter  = require 'routers/general/custom-router'

module.exports = class TrainerRouter extends CustomRouter

  appRoutes:
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
    'users/:id(/)': 'profile'
    'properties(/)': 'properties'

    'exercises_folder(/:id)(/)': 'exercisesFolderView'
    'workout_templates_folder(/:id)(/)': 'workoutTemplatesFolderView'
    'program_templates_folder(/:id)(/)': 'programTemplatesFolderView'

    'exercises/:id(/)': 'exercisesView'
    'workout_templates/:id(/)': 'workoutConstructor'
    'program_templates/:id(/)': 'programConstructor'

    'tr/global/:assign(/)': 'globalView'
    'tr/global/:assign/id/:id(/)': 'globalView'

  before: (methodName) ->
    App.request 'auth:isAuthorizedAs', 'trainer'
    App.vent.trigger 'module:main-trainer:beforeAction'
    $('html, body').animate { scrollTop: 0 }, 'fast'
