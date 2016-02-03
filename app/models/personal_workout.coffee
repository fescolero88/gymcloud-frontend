define [
  './concerns/nested_models'
  'collections/workout_exercises'
], (
  NestedModelsConcern
  WorkoutExercises
) ->

  class PersonalWorkout extends Backbone.Model

    type: 'PersonalWorkout'

    urlRoot: '/personal_workouts'

    constructor: ->
      @_nestedModelsInit
        exercises: WorkoutExercises
      super

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

    person: ->
      person_id = @get('person_id')
      App.request('current_user').clients.get(person_id)

  _.extend(PersonalWorkout::, NestedModelsConcern)

  PersonalWorkout