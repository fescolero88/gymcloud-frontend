define ->

  class Stats extends Backbone.Collection

    symbols: [
      'clients'
      'client_groups'
      'program_templates'
      'workout_templates'
      'exercises'
      'personal_programs'
      'personal_workouts'
    ]

    build: (user) ->
      @reset _.map @symbols, (symbol) =>
        {
          count: count = @_getCountBySymbol(symbol, user)
          title: @_getTitleBySymbol(symbol, count)
          path: @_getPathBySymbol(symbol, user)
        }

    _getCountBySymbol: (symbol, user) ->
      user[symbol].length

    _getTitleBySymbol: (symbol, count) ->
      _.chain(symbol).humanize().pluralize(count)

    _getPathBySymbol: (symbol, user) ->
      _.result({
        clients: ->
          '#tr/clients/individuals'
        client_groups: ->
          '#tr/clients/groups'
        program_templates: =>
          id = @_getRootFolderId('Programs', user)
          "#program_templates_folder/#{id}"
        workout_templates: =>
          id = @_getRootFolderId('Workouts', user)
          "#workout_templates_folder/#{id}"
        exercises: =>
          id = @_getRootFolderId('Exercises', user)
          "#exercises_folder/#{id}"
      }, symbol) || '#'

    _getRootFolderId: (name, user) ->
      user.folders.findWhere(name: name).get('id')
