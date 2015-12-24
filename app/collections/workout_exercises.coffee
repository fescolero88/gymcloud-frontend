define [
  'models/workout_exercise'
], (
  WorkoutExercise
) ->

  class WorkoutExercises extends Backbone.Collection

    type: 'WorkoutExercises'

    model: WorkoutExercise

    initialize: ->
      @listenTo(@, 'add remove', @_updateAllPositions)

    comparator: 'position'

    addExercise: (args = {}) ->
      attrs = _.pick args, [
        'exercise_id'
        'workout_id'
        'order_name'
      ]...
      model = new @model(attrs)
      model.save()
        .then =>
          @add(model)

    _updateAllPositions: ->
      @each (model, index) ->
        model.set('position', index + 1)
