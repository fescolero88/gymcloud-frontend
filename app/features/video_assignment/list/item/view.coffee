define [
  'moment'
  './template'
],(
  moment
  template
)->
  class AssignVideoView extends Marionette.ItemView

    template: template

    tagName: 'div'

    className: 'col-xs-4 gc-video-thumb'

    ui:
      assignVideo: '.gc-assign-video'
      player: '.gc-video-preview'

    triggers:
      'click @ui.assignVideo': 'assign'

    events:
      'click .gc-video-play': 'renderIframe'

    behaviors:

      stickit:
        bindings:
          '.gc-video-icon':
            observe: 'filter'
            update: ($el, val, model, options) ->
              $el.addClass "gc-video-#{model.get('filter')}-icon"
          '.gc-video-preview':
            observe: 'preview_picture_url'
            update: ($el, val, model, options) ->
              $el.css 'background-image', "url(#{val})"

    templateHelpers: =>
      isAssigned: @isAssigned
      durationTime: @convertDuration(@model.get('duration'))

    initialize: (options) ->
      @isAssigned = options.isAssigned
      @listenTo(this, 'destroyIframe', @destroyIframe)

    renderIframe: (ev) ->
      @trigger('playVideo')
      iframe = document.createElement('iframe')
      iframe.setAttribute('src', "#{@model.get('embed_url')}?autoplay=1")
      iframe.setAttribute('allowfullscreen', 'allowfullscreen')
      @ui.player.append(iframe)
      $(ev.currentTarget).hide()

    destroyIframe: ->
      @ui.player.find('iframe').remove()
      @ui.player.find('i').show()

    convertDuration: (duration) ->
      return null unless duration
      format = if duration > 60*60 then "HH:mm:ss" else "mm:ss"
      moment.utc(duration*1000).format(format)