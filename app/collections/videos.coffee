define [
  'models/videos'
], (
  VideoModel
) ->

  class VideosCollection extends Backbone.Collection

    url: '/videos'

    model: VideoModel