define ->

  (App) ->

    App.data = {}

    App.reqres.setHandlers

      'data:profile': ->
        App.data.profileModel

      'data:exercises': ->
        App.data.exercises

      'data:exercises:root': ->
        App.data.exercisesRoot

      'data:exercises:reset', (data) ->
        App.data.exercises = data
        true

      'data:exercises:root:reset', (key) ->
        App.data.exercisesRoot = key

      'data:workouts': ->
        App.data.workouts

      'data:workouts:root': ->
        App.data.workoutsRoot

      'data:workouts:reset', (data) ->
        App.data.workouts = data
        true

      'data:workouts:root:reset', (key) ->
        App.data.workoutsRoot = key

      'data:programs': ->
        App.data.programs

      'data:programs:root': ->
        App.data.programsRoot

      'data:programs:reset', (data) ->
        App.data.programs = data
        true

      'data:programs:root:reset', (key) ->
        App.data.programsRoot = key

      'data:properties:reset', (properties) ->
        App.data.properties = properties

      'data:properties': ->
        App.data.properties

      'data:properties:clear': ->
        delete App.data.properties

      'data:exercises:clear': ->
        delete App.data.exercises

      'data:workouts:clear': ->
        delete App.data.workouts

      'data:programs:clear': ->
        delete App.data.programs

      'client:properties': (id) ->
        App.data['client:properties']?[id]

      'client:properties:set': (id, properties) ->
        App.data['client:properties'] ?= {}
        App.data['client:properties'][id] = properties

      'my:properties': =>
        profile = @request 'data:profile'
        App.data['client:properties']?[profile.get('id')]

      'my:properties:set': (properties) =>
        profile = @request 'data:profile'
        App.data['client:properties'] ?= {}
        App.data['client:properties'][profile.get('id')] = properties

      'lastHash:get': ->
        App.data.lastHash

      'lastHash:set': (params) ->
        App.data.lastHash =
          hash: params.hash
          action: params.name

      'data:delete': (category, key) ->
        items = App.data[category]
        deleteFromTree = (items, key) =>
          for item, index in items
            if item.isFolder
              deleteFromTree item.items, key
            else if item.key is key
              items.splice index, 1
              return
        deleteFromTree items, key
