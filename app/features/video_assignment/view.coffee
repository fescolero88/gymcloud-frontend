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
      exerciseVideos: 'region.gc-exercises-videos'
      search: 'region.video-search'

    ui:
      innerNavItems: '.gc-assign-video-filter li'
      innerNavLinks: '.gc-assign-video-filter li a'
      uploadButton: '.gc-upload-video'

    className: 'gc-exercises-assign-videos'

    events:
      'click @ui.innerNavLinks': 'changeViewEvent'
      'click @ui.uploadButton': 'openUploadPopup'

    behaviors:
      video_assign: true
      pagination: true

    constructor: ->
      @collection = new VideosCollection
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
      @listenTo(@view, 'assignVideo', @assignVideo)
      @listenTo(@searchInput, 'searchStart', @searchVideos)

    onShow: ->
      @getRegion('exerciseVideos').show(@view)
      @getRegion('search').show(@searchInput)

    changeViewEvent: (ev) ->
      ev.preventDefault()
      navItem = $(ev.currentTarget).parent()
      @searchScope = $(ev.currentTarget).data('scope')
      unless $(navItem).hasClass 'active'
        @ui.innerNavItems.removeClass 'active'
        $(navItem).addClass 'active'
        query = _.trim(@searchInput.model.get('query'))
        if query
          @searchVideos(query)
        else
          @collection.reset()
          @view.viewState.set('state', 'search_not_started')

    searchVideos: (query) ->
      @request.abort() if @request?.state() is 'pending'
      unless _.trim(query)
        @view.viewState.set('state', 'search_not_started')
        return
      @request = @collection.search(query, @searchScope)
      @request
        .then (response) =>
          @view.viewState.set('state', 'no_results') unless response.length
          @collection.reset(response)
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
      @trigger('assignVideo', model)