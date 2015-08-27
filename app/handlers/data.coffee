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
