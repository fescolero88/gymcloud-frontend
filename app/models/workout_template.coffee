define [
  './workout_exercise'
  './personal_workout'
], (
  WorkoutExercise
  PersonalWorkout
) ->
  Exercises = Backbone.Collection.extend(model: WorkoutExercise)

  class WorkoutTemplate extends Backbone.Model

    urlRoot: '/workout_templates/'

    defaults:
      is_visible: true

    validation:
      name:
        required: true

    initialize: (_options) ->
      @__defineGetter__ 'parent', @_getFolder
      @__defineGetter__ 'folder', @_getFolder
      @__defineGetter__ 'author', @_getAuthor

    parse: (data) ->
      @_parseExercises(data.exercises) && delete data.exercises
      @_parseAssignees(data.assignees) && delete data.assignees
      data

    assignTo: (user) ->
      assignment = new PersonalWorkout
        person_id: user.id
        workout_template_id: @id

      assignment.save().then ->
        currentUser = App.request('current_user')
        if user.id == App.request('current_user_id')
          currentUser.personal_workouts.add(assignment)

    _getFolder: ->
      user = App.request('current_user')
      collection = user.folders
      collection.get(@get('folder_id'))

    _parseExercises: (exercises) ->
      @exercises ||= new Exercises
      if @exercises.length is 0
        @exercises.add(exercises, parse: true)

    _parseAssignees: (assignees) ->
      template = this
      items = _.map assignees, (item) ->
        collection = App.request('current_user').personal_workouts
        personalWorkout = collection.get(@id)
        unless personalWorkout
          item.__defineGetter__('workout_template_id', -> template.id)
          personalWorkout = new PersonalWorkout(item)
        personalWorkout
      @assignees = new Backbone.Collection(items)

    _getAuthor: ->
      author_id = @get('author_id')
      user = App.request('current_user')
      author = user.clients.get(author_id) || user.pros.get(author_id)
      unless author
        author = new User(id: author_id)
        author.fetch()
      author

