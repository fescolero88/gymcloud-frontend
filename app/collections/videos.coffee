define [
  'models/videos'
  'backbone.paginator'
], (
  VideoModel
  PageableCollection
) ->
  class VideosCollection extends Backbone.PageableCollection

    url: ->
      '/videos'

    model: VideoModel

    search: (q, scope = 'mine') ->
      options = App.request 'ajax:options:create',
        url: "#{@url()}/search"
        type: 'GET'
        data: $.param
          q: q
          scope: scope

      sync = Backbone.sync
      sync.call(@, null, @, options)

    getPreviousPage: ->
      return false if @state.currentPage <= 1
      super