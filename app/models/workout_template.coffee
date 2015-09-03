define [
  'backbone'
  './workout_exercise'
  './personal_workout'
], (
  Backbone
  WorkoutExercise
  PersonalWorkout
) ->
  Exercises = Backbone.Collection.extend(model: WorkoutExercise)

  class WorkoutTemplate extends Backbone.Model

    urlRoot: '/workout_templates/'

    validation:

      name:
        required: true

    parse: (data) ->
      @_parseExercises(data.exercises) && delete data.exercises
      @_parseAssignees(data.assignees) && delete data.assignees
      data

    _parseExercises: (exercises) ->
      @exercises ||= new Exercises
      if @exercises.length is 0
        @exercises.add(exercises, parse: true)

    _parseAssignees: (assignees) ->
      template = this
      items = _.map assignees, (item) ->
        collection = App.request('current_user').personal_workouts
        personalWorkout = collection.get(@id)
        personalWorkout ||= new PersonalWorkout
          id: item.id
          person_id: item.person_id
          workout_template_id: template.id
        personalWorkout
      @assignees = new Backbone.Collection(items)
