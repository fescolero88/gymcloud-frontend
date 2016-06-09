define [
  'models/exercise_result'
], (
  ExerciseResult
) ->

  class ExerciseResults extends Backbone.Collection

    type: 'ExerciseResults'

    model: ExerciseResult
