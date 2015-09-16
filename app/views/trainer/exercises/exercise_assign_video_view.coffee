define [
  'templates/trainer/exercises/exercise_assign_video'
],(
  template
)->
  class ExerciseAssignVideoView extends Marionette.ItemView

    template: template

    tagName: 'div'

    className: 'col-xs-4'

    behaviors:

      stickit:
        bindings:
          '[data-bind="title"]': 'title'
          '[data-bind="duration"]': 'duration'
          '[data-bind="filter"]': 'filter'
          '.gc-video-icon':
            observe: 'filter'
            update: ($el, val, model, options) ->
              $el.addClass "gc-video-#{model.get('filter')}-icon"
          '.gc-preview':
            observe: 'preview'
            update: ($el, val, model, options) ->
              $el.attr 'src', model.get('preview')