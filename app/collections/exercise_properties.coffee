define [
  'models/exercise_property'
], (
  ExerciseProperty
) ->

  class ExerciseProperties extends Backbone.Collection

    type: 'ExerciseProperties'

    model: ExerciseProperty

    addProperties: (sourceCollection, workout_exercise_id) ->
      sourceCollection.each (sourceModel) =>
        model = new ExerciseProperty(sourceModel.attributes)
        model.set
          workout_exercise_id: workout_exercise_id
        model.save()
          .then =>
            @add(model)

    initProperty: (workout_exercise_id, default_property = {}) ->
      model = new ExerciseProperty
        workout_exercise_id: workout_exercise_id
        position: @length
        personal_property: default_property
        personal_property_id: default_property.id
        value: 0
      @add(model)

