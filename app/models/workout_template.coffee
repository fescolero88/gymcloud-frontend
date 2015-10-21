define [
  './workout_exercise'
  './personal_workout'
  './client_group'
], (
  WorkoutExercise
  PersonalWorkout
  ClientGroup
) ->

  class WorkoutTemplate extends Backbone.Model

    type: 'WorkoutTemplate'

    urlRoot: '/workout_templates/'

    defaults:
      is_visible: true

    validation:
      name:
        required: true

    constructor: (_attributes) ->
      Exercises = Backbone.Collection.extend(model: WorkoutExercise)
      Groups = Backbone.Collection.extend(model: ClientGroup)
      @exercises = new Exercises
      @assignees = new Backbone.Collection
      @groupAssignments = new Groups
      super

    initialize: (_options) ->
      @__defineGetter__ 'parent', @_getFolder
      @__defineGetter__ 'folder', @_getFolder
      @__defineGetter__ 'author', @_getAuthor

    parse: (data) ->
      data.exercises &&
        @_parseExercises(data.exercises) &&
        delete data.exercises
      data.assignees &&
        @_parseAssignees(data.assignees) &&
        delete data.assignees
      data.group_assignments &&
        @_parseGroupAssignments(data.group_assignments) &&
        delete data.group_assignments
      data

    assignTo: (user) ->
      assignment = new PersonalWorkout
        person_id: user.id
        workout_template_id: @id

      assignment.save()

    _getFolder: ->
      user = App.request('current_user')
      collection = user.folders
      collection.get(@get('folder_id'))

    _parseExercises: (exercises) ->
      @exercises.reset(exercises, parse: true)

    _parseGroupAssignments: (assignments) ->
      @groupAssignments.reset(assignments, parse: true)

    _parseAssignees: (assignees) ->
      template = this
      items = _.map assignees, (item) ->
        collection = App.request('current_user').personal_workouts
        personalWorkout = collection.get(item.id)
        unless personalWorkout
          item.workout_template_id = template.id
          personalWorkout = new PersonalWorkout(item)
        personalWorkout
      @assignees.reset(items)

    _getAuthor: ->
      author_id = @get('author_id')
      user = App.request('current_user')
      author = user.clients.get(author_id) || user.pros.get(author_id)
      unless author
        author = new User(id: author_id)
        author.fetch()
      author

