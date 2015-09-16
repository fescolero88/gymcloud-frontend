define [
  'templates/trainer/exercises/exercise_global_assign_video'
  'features/assign_videos/view'
  'collections/videos_collection'
], (
  template
  AssignVideoView
  ExerciseVideosCollection
) ->
  class VideosView extends Marionette.LayoutView

    template: template

    regions:
      exerciseVideos: 'region.gc-exercises-videos'

    onShow: ->
      @collection = new ExerciseVideosCollection [
        preview: 'https://placehold.it/350x220'
        duration: '0:12'
        filter: 'youtube'
        title: 'Lorem Ipsum 1'
        is_assigned: false
      ,
        preview: 'https://placehold.it/350x220'
        duration: '0:12'
        filter: 'public'
        title: 'Lorem Ipsum 2'
        is_assigned: false
      ,
        preview: 'https://placehold.it/350x220'
        duration: '0:12'
        filter: 'library'
        title: 'Lorem Ipsum 3',
        is_assigned: true
      ,
        preview: 'https://placehold.it/350x220'
        duration: '0:12'
        filter: 'public'
        title: 'Lorem Ipsum 4'
        is_assigned: false
      ,
        preview: 'https://placehold.it/350x220'
        duration: '0:12'
        filter: 'public'
        title: 'Lorem Ipsum 5'
        is_assigned: true
      ,
        preview: 'https://placehold.it/350x220'
        duration: '0:12'
        filter: 'youtube'
        title: 'Lorem Ipsum 6'
        is_assigned: false
      ]
      view = new AssignVideoView collection: @collection
      @getRegion('exerciseVideos').show view