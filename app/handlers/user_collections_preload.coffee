define [
  'backbone'
  'lodash'
  'collections/user_collection'
  'models/workout_template'
  'models/program_template'
  'models/personal_program'
  'models/personal_property'
  'models/personal_workout'
], (
  Backbone
  _
  UserCollection
  WorkoutTemplate
  ProgramTemplate
  PersonalProgram
  PersonalProperty
  PersonalWorkout
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
      workout_events: Backbone.Model
      folders: Backbone.Model
      notifications: Backbone.Model

    _.map collections, (model, item) ->
      collection = new UserCollection [],
        model: model
        user: user
        type: item
      user.__defineGetter__(item, -> collection)
      collection.fetch()