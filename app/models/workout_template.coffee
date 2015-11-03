define [
  'collections/workout_exercises'
  './personal_workout'
  './client_group'
], (
  WorkoutExercises
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

    constructor: ->
      Groups = Backbone.Collection.extend(model: ClientGroup)
      @exercises = new WorkoutExercises
      @assignees = new Backbone.Collection
      @groupAssignments = new Groups
      super

    #initialize: (_options) ->
      #@__defineGetter__ 'parent', @_getFolder
      #@__defineGetter__ 'folder', @_getFolder

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
      template = @
      items = _.map assignees, (item) ->
        collection = App.request('current_user').personal_workouts
        personalWorkout = collection.get(item.id)
        unless personalWorkout
          item.workout_template_id = template.id
          personalWorkout = new PersonalWorkout(item)
        personalWorkout
      @assignees.reset(items)
