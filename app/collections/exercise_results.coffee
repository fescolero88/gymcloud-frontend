define [
  'models/exercise_result'
], (
  ExerciseResult
) ->

  class ExerciseResults extends Backbone.Collection

    type: 'ExerciseResults'

    model: ExerciseResult

    createWithItems: (result, resultItems) ->
      @add(result)
      promise = result.save()
      promise.then ->
        result.exercise_result_items.add(resultItems)
        result.exercise_result_items.each((item) -> item.save())
      promise

    destroyAll: ->
      promises = @map((result) -> result.destroy(wait: true))
      $.when(promises...)
