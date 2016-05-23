define [
  'moment'
], (
  moment
)->

  class VideoFeatures extends Marionette.Behavior

    key: 'video_features'

    ui:
      player: '.gc-video-preview'
      play: '.gc-video-play'
      duration: '.gc-video-duration'

    events:
      'click @ui.play': 'renderIframe'

    initialize: ->
      @model = @view.options.model
      @listenTo(@view, 'destroyIframe', @destroyIframe)

    onShow: ->
      @convertDuration(@model.get('duration'))

    renderIframe: (ev) ->
      @view.trigger('playVideo')
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
      format = if duration > 60 * 60 then 'HH:mm:ss' else 'mm:ss'
      duration = moment.utc(duration * 1000).format(format)
      @ui.duration.html(duration)