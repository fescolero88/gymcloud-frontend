define [
  'views/trainer/exercises/exercise_assign_video_view'
], (
  ExerciseAssignVideoView
) ->
  class ExerciseAssignVideosView extends Marionette.CollectionView

    tagName: 'div'

    className: 'row'

    childView: ExerciseAssignVideoView
