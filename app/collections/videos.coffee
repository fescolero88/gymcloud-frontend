define [
  'models/videos'
], (
  VideoModel
) ->

  class VideosCollection extends Backbone.Collection

    url: ->
      '/videos'

    model: VideoModel

    search: (q, scope = 'gymcloud') ->
      options = App.request 'ajax:options:create',
        url: "#{@url()}/search"
        type: 'GET'
        data: $.param
          q: q
          scope: scope

      sync = (@sync || Backbone.sync)
      sync.call(@, null, @, options)