define [
  'backbone'
  'collections/program_workouts'
], (
  Backbone
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
      data

    _getFolder: ->
      user = App.request('current_user')
      collection = user.folders
      collection.get(@get('folder_id'))

    _parseProgramWorkouts: (workouts) ->
      @program_workouts ||= new ProgramWorkouts
      @program_workouts.add(workouts, parse: true, merge: true)