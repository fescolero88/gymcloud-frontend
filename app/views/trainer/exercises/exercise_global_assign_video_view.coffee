define [
  'templates/trainer/exercises/exercise_global_assign_video'
  'views/trainer/exercises/exercise_assign_videos_view'
  'collections/exercise_videos'
], (
  template
  ExerciseAssignVideosView
  ExerciseVideosCollection
) ->
  class ExerciseGlobalAssignVideoView extends Marionette.LayoutView

    template: template

    regions:
      exerciseVideos: 'region.gc-exercises-videos'

    onShow: ->
      @collection = new ExerciseVideosCollection [
        preview: 'https://placehold.it/400x300'
        duration: '0:12'
        filter: 'youtube'
        title: 'Lorem Ipsum 1'
      ,
        preview: 'https://placehold.it/400x300'
        duration: '0:12'
        filter: 'public'
        title: 'Lorem Ipsum 2'
      ,
        preview: 'https://placehold.it/400x300'
        duration: '0:12'
        filter: 'library'
        title: 'Lorem Ipsum 3'
      ,
        preview: 'https://placehold.it/400x300'
        duration: '0:12'
        filter: 'public'
        title: 'Lorem Ipsum 4'
      ,
        preview: 'https://placehold.it/400x300'
        duration: '0:12'
        filter: 'public'
        title: 'Lorem Ipsum 5'
      ,
        preview: 'https://placehold.it/400x300'
        duration: '0:12'
        filter: 'youtube'
        title: 'Lorem Ipsum 6'
      ]
      view = new ExerciseAssignVideosView collection: @collection
      @getRegion('exerciseVideos').show view