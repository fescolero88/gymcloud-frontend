define [
  './auth'
  './clients'
  './client_groups'
  './dashboard'
  './exercises'
  './folders'
  './other'
  './personal_properties'
  './program_templates'
  './personal_programs'
  './users'
  './workout_templates'
  './personal_workouts'
  './workout_exercises'
  './prototype'
  './old_client_router'
  './payments'
  './video_library'
], ->

  modules = _.toArray(arguments)

  class Module extends Marionette.Module

    initialize: ->

      @on 'start', ->
        _.each modules, (module) ->
          module.init()
