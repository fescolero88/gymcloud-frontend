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

    events:
      'click @ui.assignVideo': 'toggleAssign'

    behaviors:

      stickit:
        bindings:
          '.gc-video-icon':
            observe: 'filter'
            update: ($el, val, model, options) ->
              $el.addClass "gc-video-#{model.get('filter')}-icon"
          '.gc-preview':
            observe: 'preview'
            update: ($el, val, model, options) ->
              $el.attr 'src', model.get('preview')
          '.gc-assign-video':
            observe: 'is_assigned'
            update: ($el, val, model, options) ->
              if model.get('is_assigned')
                $el.html('assigned').addClass('assigned')
              else
                $el.html('assign this video').removeClass('assigned')

    toggleAssign: ->
      @model.set 'is_assigned', !@model.get('is_assigned')