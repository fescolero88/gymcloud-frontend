define ->

  class VideoAssign extends Marionette.Behavior

    initialize: ->
      @listenTo(@view, 'assignVideo', @assignVideo)

    assignVideo: (videoModel) ->
      attributes = {
        'video_url': videoModel.get('embed_url')
      }
      if videoModel.get('type') is 'gymcloud'
        attributes.video_id = videoModel.get('id')
      else
        attributes.video_id = null
      @view.model.save(attributes, wait: true)