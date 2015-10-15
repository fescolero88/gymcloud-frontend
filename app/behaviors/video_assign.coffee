define ->

  class VideoAssignBehavior extends Marionette.Behavior

    initialize: ->
      @listenTo(@view, 'assignVideo', @_assignVideo)

    _assignVideo: (videoModel) ->
      attributes =
        video_url: videoModel.get('embed_url')
        video_id: @_getVideoId(videoModel)
      @view.model.save(attributes, wait: true)

    _getVideoId: (model) ->
      if model.get('type') is 'gymcloud'
        video_id = model.get('id')
      else
        video_id = null