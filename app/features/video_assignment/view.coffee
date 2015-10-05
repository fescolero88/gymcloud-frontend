define [
  './template'
  './list/view'
  'collections/videos'
], (
  template
  AssignVideoView
  ExerciseVideosCollection
) ->
  class VideosView extends Marionette.LayoutView

    template: template

    regions:
      exerciseVideos: 'region.gc-exercises-videos'

    ui:
      innerNavItems: '.gc-assign-video-filter li'
      innerNavLinks: '.gc-assign-video-filter li a'

    className: 'gc-exercises-assign-videos'

    events:
      'click @ui.innerNavLinks': 'changeViewEvent'

    initialize: ->
      collection = new ExerciseVideosCollection
      collection.fetch()
      @view = new AssignVideoView(
        collection: collection
        model: @model
      )
      @listenTo(@view, 'assignVideo', @assignVideo)

    onShow: ->
      @getRegion('exerciseVideos').show(@view)

    changeViewEvent: (ev) ->
      ev.preventDefault()
      navItem = $(ev.currentTarget).parent()
      unless $(navItem).hasClass 'active'
        @ui.innerNavItems.removeClass 'active'
        $(navItem).addClass 'active'

    assignVideo: (videoModel) ->
      @model.save({
        'video_url': videoModel.get('embed_url')
      }, wait: true).then ->
        App.request 'messenger:show',
          message: 'Video is assigned'