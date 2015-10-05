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

    initialize: (options) ->
      @isAssigned = options.isAssigned
