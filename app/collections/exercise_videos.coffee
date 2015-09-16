define [
  'models/exercise_video'
], (
  ExerciseVideoModel
) ->

  class ExerciseVideosCollection extends Backbone.Collection

    model: ExerciseVideoModel
