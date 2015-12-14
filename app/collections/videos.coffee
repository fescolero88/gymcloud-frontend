define [
  'models/videos'
  'backbone.paginator'
], (
  Video
  PageableCollection
) ->

  class Videos extends Backbone.PageableCollection

    type: 'Videos'

    url: ->
      '/videos/search'

    model: Video

    queryParams:
      q: null
      scope: 'mine'

    getPreviousPage: ->
      return false if @state.currentPage <= 1
      super
