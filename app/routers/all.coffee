define [
  './auth'
  './clients'
  './dashboard'
  './exercises'
  './folders'
  './other'
  './personal_properties'
  './program_templates'
  './users'
  './workout_templates'
  './personal_workouts'
  './prototype'
  './old_client_router'
], ->

  modules = _.toArray(arguments)

  class Module extends Marionette.Module

    initialize: ->

      @on 'start', ->
        _.each modules, (module) ->
          module.init()
