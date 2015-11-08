define [
  'models/videos'
  'backbone.paginator'
], (
  VideoModel
  PageableCollection
) ->
  class VideosListCollection extends Backbone.PageableCollection

    url: ->
      '/videos'

    model: VideoModel

    getPreviousPage: ->
      return false if @state.currentPage <= 1
      super