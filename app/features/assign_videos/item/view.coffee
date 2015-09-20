define [
  './template'
],(
  template
)->
  class AssignVideoView extends Marionette.ItemView

    template: template

    tagName: 'div'

    className: 'col-xs-4'

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