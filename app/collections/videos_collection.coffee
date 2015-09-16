define [
  'models/videos_model'
], (
  VideosModel
) ->

  class VideosCollection extends Backbone.Collection

    model: VideosModel
