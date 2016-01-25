define ->

  class Stats extends Backbone.Collection

    symbols:
      client: [
        'workout_exercises'
        'personal_workouts'
        'personal_programs'
      ]
      pro: [
        'clients'
        'client_groups'
        'exercises'
        'workout_templates'
        'program_templates'
        'personal_workouts'
        'personal_programs'
      ]

    build: (user) ->
      symbols = if user.get('is_pro') then @symbols.pro else @symbols.client
      data = _.chain(symbols)
        .select((symbol) ->
          user[symbol] instanceof Backbone.Collection
        )
        .map((symbol) =>
          {
            count: count = @_getCountBySymbol(symbol, user)
            title: @_getTitleBySymbol(symbol, count)
            path: @_getPathBySymbol(symbol, user)
          }
        )
        .value()

      @reset(data)

    _getCountBySymbol: (symbol, user) ->
      user[symbol].length

    _getTitleBySymbol: (symbol, count) ->
      _.chain(symbol)
        .humanize()
        .singularize()
        .pluralize(count)
        .value()

    _getPathBySymbol: (symbol, user) ->
      _.result({
        clients: ->
          '#clients/individuals'
        client_groups: ->
          '#clients/groups'
        exercises: =>
          id = @_getRootFolderId('Exercises', user)
          "#exercises_folder/#{id}"
        workout_templates: =>
          id = @_getRootFolderId('Workouts', user)
          "#workout_templates_folder/#{id}"
        program_templates: =>
          id = @_getRootFolderId('Programs', user)
          "#program_templates_folder/#{id}"
        workout_exercises: ->
          '#workout_exercises'
        personal_workouts: ->
          '#personal_workouts'
        personal_programs: ->
          '#personal_programs'
      }, symbol) || '#'

    _getRootFolderId: (name, user) ->
      user.folders.findWhere(name: name).get('id')
