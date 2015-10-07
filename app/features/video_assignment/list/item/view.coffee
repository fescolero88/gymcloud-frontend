define [
  './template'
],(
  template
)->
  class AssignVideoView extends Marionette.ItemView

    template: template

    tagName: 'div'

    className: 'col-xs-4'

    ui:
      assignVideo: '.gc-assign-video'

    triggers:
      'click @ui.assignVideo': 'assign'

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

    convertDuration: (duration) ->
      return null unless duration
      minutes = Math.floor(duration / 60)
      seconds = duration - minutes * 60
      "#{_.lpad(minutes, 2, "0")}:#{_.lpad(seconds, 2, "0")}"