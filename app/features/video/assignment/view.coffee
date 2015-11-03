define [
  './template'
  './list/view'
  './search/view'
  'collections/videos'
], (
  template
  AssignVideosView
  SearchInputView
  VideosCollection
) ->

  class VideosView extends Marionette.LayoutView

    template: template

    regions:
      videos: 'region.gc-videos'
      search: 'region.video-search'

    ui:
      innerNavItems: '.gc-assign-video-filter li'
      innerNavLinks: '.gc-assign-video-filter li a'
      uploadButton: '.gc-upload-video'

    className: 'gc-assign-video-layout'

    events:
      'click @ui.innerNavLinks': 'changeViewEvent'
      'click @ui.uploadButton': 'openUploadPopup'

    behaviors:
      pagination: true

    constructor: ->
      @collection = new VideosCollection
      @searchScope = 'mine'
      super

    initialize: ->
      @request = null
      @searchInput = new SearchInputView(
        model: new Backbone.Model
      )
      @view = new AssignVideosView(
        collection: @collection
        model: @model
      )
      @listenTo(@view, 'video:assigned', @assignVideo)
      @listenTo(@searchInput, 'searchStart', @searchVideos)

    onShow: ->
      @getRegion('videos').show(@view)
      @getRegion('search').show(@searchInput)

    changeViewEvent: (ev) ->
      navItem = $(ev.currentTarget).parent()
      @searchScope = $(ev.currentTarget).data('scope')
      unless $(navItem).hasClass 'active'
        @ui.innerNavItems.removeClass 'active'
        $(navItem).addClass 'active'
        query = _.trim(@searchInput.model.get('query'))
        if query
          @collection.reset()
          @view.viewState.set('state', 'in_progress')
          @searchVideos(query)
        else if !query and @searchScope is 'mine'
          @collection.reset()
          @view.viewState.set('state', 'library')
        else
          @view.viewState.set('state', 'search_not_started')
          @collection.reset()

    searchVideos: (query) ->
      @request.abort() if @request?.state() is 'pending'
      unless _.trim(query)
        @view.viewState.set('state', 'search_not_started')
        return

      @collection.queryParams.q = query
      @collection.queryParams.scope = @searchScope
      @request = @collection.fetch
        data:
          q: query
          scope: @searchScope
        reset: true

      @request
        .then (response) =>
          @view.viewState.set('state', 'no_results') unless response.length
        .fail ->
          return false if arguments[1] is 'abort'
          App.request 'messenger:show',
            message: 'Videos search error'
            type: 'error'

    openUploadPopup: ->
      view = App.request('base:uploadVideo')
      @listenToOnce(view, 'videoUploaded', @_videoUploaded)

    _videoUploaded: (model) ->
      @assignVideo(model)
      @collection.unshift(model)

    assignVideo: (model) ->
      attrs =
        video_url: model.get('embed_url')
        video_id: @_getVideoId(model)
      @model.save(attrs, wait: true)
        .then =>
          @trigger('video:assigned')

    _getVideoId: (model) ->
      if model.get('type') is 'gymcloud'
        model.get('id')
      else
        null
