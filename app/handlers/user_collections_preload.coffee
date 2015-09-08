define [
  'backbone'
  'lodash'
  'collections/user_collection'
  'collections/library'
  'models/workout_template'
  'models/program_template'
  'models/personal_program'
  'models/personal_property'
  'models/personal_workout'
  'models/folder'
], (
  Backbone
  _
  UserCollection
  Library
  WorkoutTemplate
  ProgramTemplate
  PersonalProgram
  PersonalProperty
  PersonalWorkout
  Folder
)->
  (user) ->
    collections =
      pros: Backbone.Model
      clients: Backbone.Model
      client_groups: Backbone.Model
      exercises: Backbone.Model
      workout_templates: WorkoutTemplate
      program_templates: ProgramTemplate
      personal_programs: PersonalProgram
      personal_properties: PersonalProperty
      personal_workouts: PersonalWorkout
      folders: Folder
      notifications: Backbone.Model
      library: Folder
      # workout_events: Backbone.Model

    user.library = new Library
    promises = _.map collections, (model, item) ->
      collection = new UserCollection [],
        model: model
        user: user
        type: item
      user.__defineGetter__(item, -> collection)
      collection.fetch()
    promises.push(user.library.fetch())

    promises