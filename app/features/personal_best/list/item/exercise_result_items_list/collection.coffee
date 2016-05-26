define [
  './model'
], (
  ExerciseResultItem
) ->

  class ExerciseResultItemCollection extends Backbone.Collection

    model: ExerciseResultItem

    url: ->
      "/exercise_results/#{@exerciseId}/items"

    initialize: (models, options) ->
      @exerciseId = options?.exerciseId
