define [
  './template'
  './list/view'
  './search/view'
  'collections/videos'
], (
  template
  AssignVideoView
  SearchView
  ExerciseVideosCollection
) ->
  class VideosView extends Marionette.LayoutView

    template: template

    regions:
      exerciseVideos: 'region.gc-exercises-videos'
      search: 'region.video-search'

    ui:
      innerNavItems: '.gc-assign-video-filter li'
      innerNavLinks: '.gc-assign-video-filter li a'

    className: 'gc-exercises-assign-videos'

    events:
      'click @ui.innerNavLinks': 'changeViewEvent'

    initialize: ->
      @collection = new ExerciseVideosCollection
      @search = new SearchView
      @request = null
      @collection.fetch()
      @view = new AssignVideoView(
        collection: @collection
        model: @model
      )
      @listenTo(@view, 'assignVideo', @assignVideo)
      @listenTo(@search, 'searchStart', @searchVideos)

    onShow: ->
      @getRegion('exerciseVideos').show(@view)
      @getRegion('search').show(@search)

    changeViewEvent: (ev) ->
      ev.preventDefault()
      navItem = $(ev.currentTarget).parent()
      @searchScope = $(ev.currentTarget).data('scope')
      unless $(navItem).hasClass 'active'
        @ui.innerNavItems.removeClass 'active'
        $(navItem).addClass 'active'
        query = _.trim(@search.model.get('query'))
        @searchVideos(query) if query

    assignVideo: (videoModel) ->
      @model.save({
        'video_url': videoModel.get('embed_url')
      }, wait: true).then ->
        App.request 'messenger:show',
          message: 'Video is assigned'

    searchVideos: (query) ->
      @request = @collection.search(query, @searchScope)
        .then (response) =>
          @collection.reset(response)
        .fail ->
          App.request 'messenger:show',
            message: 'Videos search error'
            type: 'error'