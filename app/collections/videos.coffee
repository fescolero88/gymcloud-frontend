define [
  'models/videos'
], (
  VideoModel
) ->

  class VideosCollection extends Backbone.Collection

    model: VideoModel
