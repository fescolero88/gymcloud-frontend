define [
  'backbone'
  './personal_program'
  './personal_workout'
  'collections/program_workouts'
], (
  Backbone
  PersonalProgram
  PersonalWorkout
  ProgramWorkouts
) ->

  class ProgramTemplate extends Backbone.Model

    urlRoot: '/program_templates/'

    validation:
      name:
        required: true

    initialize: (_options) ->
      @__defineGetter__ 'parent', @_getFolder
      @__defineGetter__ 'folder', @_getFolder

    parse: (data) ->
      @_parseProgramWorkouts(data.workouts) && delete data.workouts
      @_parseAssignees(data.assignees) && delete data.assignees
      data

    assignTo: (user) ->
      assignment = new PersonalProgram
        person_id: user.id
        program_template_id: @id

      assignment.save().then ->
        currentUser = App.request('current_user')
        if user.id == App.request('current_user_id')
          currentUser.personal_programs.add(assignment)

    _getFolder: ->
      user = App.request('current_user')
      collection = user.folders
      collection.get(@get('folder_id'))

    _parseProgramWorkouts: (workouts) ->
      @program_workouts ||= new ProgramWorkouts
      @program_workouts.add(workouts, parse: true, merge: true)

    _parseAssignees: (assignees) ->
      template = this
      items = _.map assignees, (item) ->
        collection = App.request('current_user').personal_programs
        personalProgram = collection.get(@id)
        unless personalProgram
          item.__defineGetter__('program_template_id', -> template.id)
          personalProgram = new PersonalProgram(item)
        personalProgram
      @assignees = new Backbone.Collection(items)
