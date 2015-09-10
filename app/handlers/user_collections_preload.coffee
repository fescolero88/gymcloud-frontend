define [
  'collections/user_collection'
  'models/user'
  'models/exercise'
  'models/workout_template'
  'models/program_template'
  'models/personal_program'
  'models/personal_property'
  'models/personal_workout'
  'models/folder'
], (
  UserCollection
  User
  Exercise
  WorkoutTemplate
  ProgramTemplate
  PersonalProgram
  PersonalProperty
  PersonalWorkout
  Folder
)->
  (user) ->
    collections =
      pros: User
      clients: User
      client_groups: Backbone.Model
      exercises: Exercise
      workout_templates: WorkoutTemplate
      program_templates: ProgramTemplate
      personal_programs: PersonalProgram
      personal_properties: PersonalProperty
      personal_workouts: PersonalWorkout
      folders: Folder
      notifications: Backbone.Model
      library: Folder
      # workout_events: Backbone.Model

    _.map collections, (model, item) ->
      collection = new UserCollection [],
        model: model
        user: user
        type: item
      user.__defineGetter__(item, -> collection)
      collection.fetch()