define [
  'models/videos'
  'backbone.paginator'
], (
  VideoModel
  PageableCollection
) ->
  class VideosCollection extends Backbone.PageableCollection

    url: ->
      '/videos/search'

    model: VideoModel

    queryParams:
      q: null
      scope: 'mine'

    getPreviousPage: ->
      return false if @state.currentPage <= 1
      super