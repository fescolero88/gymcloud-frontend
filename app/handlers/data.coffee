define ->

  (App) ->

    App.data = {}

    App.reqres.setHandler 'data:profile', ->
      App.data.profileModel

    App.reqres.setHandler 'data:exercises', ->
      App.data.exercises

    App.reqres.setHandler 'data:exercises:root', ->
      App.data.exercisesRoot

    App.reqres.setHandler 'data:exercises:reset', (data) ->
      App.data.exercises = data
      true

    App.reqres.setHandler 'data:exercises:root:reset', (key) ->
      App.data.exercisesRoot = key

    App.reqres.setHandler 'data:workouts', ->
      App.data.workouts

    App.reqres.setHandler 'data:workouts:root', ->
      App.data.workoutsRoot

    App.reqres.setHandler 'data:workouts:reset', (data) ->
      App.data.workouts = data
      true

    App.reqres.setHandler 'data:workouts:root:reset', (key) ->
      App.data.workoutsRoot = key

    App.reqres.setHandler 'data:programs', ->
      App.data.programs

    App.reqres.setHandler 'data:programs:root', ->
      App.data.programsRoot

    App.reqres.setHandler 'data:programs:reset', (data) ->
      App.data.programs = data
      true

    App.reqres.setHandler 'data:programs:root:reset', (key) ->
      App.data.programsRoot = key

    App.reqres.setHandler 'data:properties:reset', (properties) ->
      App.data.properties = properties

    App.reqres.setHandler 'data:properties', ->
      App.data.properties

    App.reqres.setHandler 'data:properties:clear', ->
      delete App.data.properties

    App.reqres.setHandler 'data:exercises:clear', ->
      delete App.data.exercises

    App.reqres.setHandler 'data:workouts:clear', ->
      delete App.data.workouts

    App.reqres.setHandler 'data:programs:clear', ->
      delete App.data.programs

    App.reqres.setHandler 'client:properties', (id) ->
      App.data['client:properties']?[id]

    App.reqres.setHandler 'client:properties:set', (id, properties) ->
      App.data['client:properties'] ?= {}
      App.data['client:properties'][id] = properties

    App.reqres.setHandler 'my:properties', =>
      profile = App.request 'data:profile'
      App.data['client:properties']?[profile.get('id')]

    App.reqres.setHandler 'my:properties:set', (properties) =>
      profile = App.request 'data:profile'
      App.data['client:properties'] ?= {}
      App.data['client:properties'][profile.get('id')] = properties

    App.reqres.setHandler 'lastHash:get', ->
      App.data.lastHash

    App.reqres.setHandler 'lastHash:set', (params) ->
      App.data.lastHash =
        hash: params.hash
        action: params.name

    App.reqres.setHandler 'data:delete', (category, key) ->
      items = App.data[category]
      deleteFromTree = (items, key) ->
        for item, index in items
          if item.isFolder
            deleteFromTree item.items, key
          else if item.key is key
            items.splice index, 1
            return
      deleteFromTree items, key
