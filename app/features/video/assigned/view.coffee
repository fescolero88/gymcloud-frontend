define [
  './template'
], (
  template
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'gc-video-assigned'

    behaviors:

      stickit:
        bindings:
          '.gc-video-assigned-wrapper':
            observe: 'video_url'
            visible: (value) -> !!value
          '.gc-video-assigned-placeholder':
            observe: 'video_url'
            visible: (value) -> !value
          'iframe':
            attributes: [
                name: 'src'
                observe: 'video_url'
            ]
          '.gc-video-link':
            attributes: [
                name: 'href'
                observe: 'video_url'
            ]
          '.gc-video-link span.name': 'name'
          '.gc-video-link span.type':
            observe: 'video_url'
            onGet: (value) ->
              type = @_getVideoType(value)
              _.capitalize(type)
          '.gc-video-icon':
            classes:
              'gc-video-vimeo-icon':
                observe: 'video_url'
                onGet: (value) ->
                  @_getVideoType(value) is 'vimeo'
              'gc-video-youtube-icon':
                observe: 'video_url'
                onGet: (value) ->
                  @_getVideoType(value) is 'youtube'

    ui:
      buttonDelete: '.gc-video-delete'
      buttonAssign: '.gc-add-video'

    events:
      'click @ui.buttonDelete': '_deleteVideo'
      'click @ui.buttonAssign': '_showAssignModal'

    onBeforeRender: ->
      @model = @options.model()

    _showAssignModal: ->
      App.request('modal:video:assign', @model)

    _deleteVideo: ->
      App.request 'modal:confirm',
        title: 'Delete Video?'
        content: 'Are you sure you want to delete this video?'
        confirmBtn: 'Delete'
        confirmCallBack: =>
          @model.save
            video_url: null
            video_id: null
          , wait: true

    _getVideoType: (url) ->
      return unless _.any(url)
      url.indexOf('vimeo') isnt -1 && 'vimeo' || 'youtube'
