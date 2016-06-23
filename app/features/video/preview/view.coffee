define [
  '../assigned/view'
  './template'
], (
  AssignedVideoView
  template
) ->

  class PreviewAssignedVideoView extends AssignedVideoView

    template: template

    behaviors: ->

      stickit:
        bindings:
          '.gc-video-assigned-wrapper':
            observe: 'video_url'
            visible: (value) ->
              !!value
          '.gc-video-assigned-placeholder':
            observe: 'video_url'
            visible: (value) ->
              !value

          'iframe':
            attributes: [
                name: 'src'
                observe: 'video_url'
            ]
