define [
  'backbone'
  './personal_program'
  './personal_workout'
  './client_group'
  'collections/program_workouts'
  'collections/program_weeks'
], (
  Backbone
  PersonalProgram
  PersonalWorkout
  ClientGroup
  ProgramWorkouts
  ProgramWeeks
) ->

  class ProgramTemplate extends Backbone.Model

    type: 'ProgramTemplate'

    urlRoot: '/program_templates/'

    validation:
      name:
        required: true

    initialize: (_options) ->
      @__defineGetter__ 'parent', @_getFolder
      @__defineGetter__ 'folder', @_getFolder

    constructor: ->
      Groups = Backbone.Collection.extend(model: ClientGroup)
      @program_weeks = new ProgramWeeks
      @program_workouts = new ProgramWorkouts
      @groupAssignments = new Groups
      @assignees = new Backbone.Collection
      super

    parse: (data) ->
      @_parseProgramWorkouts(data.workouts) && delete data.workouts
      @_parseAssignees(data.assignees) && delete data.assignees
      @_parseWeeks(data.weeks) && delete data.weeks
      data.group_assignments &&
        @_parseGroupAssignments(data.group_assignments) &&
        delete data.group_assignments
      data

    assignTo: (user) ->
      assignment = new PersonalProgram
        person_id: user.id
        program_template_id: @id

      assignment.save()

    _getFolder: ->
      user = App.request('current_user')
      collection = user.folders
      collection.get(@get('folder_id'))

    _parseWeeks: (weeks) ->
      @program_weeks.reset(weeks)

    _parseProgramWorkouts: (workouts) ->
      @program_workouts.reset(workouts)

    _parseGroupAssignments: (assignments) ->
      @groupAssignments.reset(assignments, parse: true)

    _parseAssignees: (assignees) ->
      template = @
      items = _.map assignees, (item) ->
        collection = App.request('current_user').personal_programs
        personalProgram = collection.get(item.id)
        unless personalProgram
          item.program_template_id = template.id
          personalProgram = new PersonalProgram(item)
        personalProgram
      @assignees.reset(items)
