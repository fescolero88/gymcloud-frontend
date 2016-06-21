define [
  './template'
], (
  template
) ->

  class ExerciseOverviewView extends Marionette.LayoutView

    key: 'ExerciseOverviewView'

    template: template

    className: 'gc-box-content'

    behaviors: ->
      privacy_toggle:
        enabled: @_enabled
      delete_button:
        enabled: @_enabled
      author_widget: true
      rating_widget: true
      editable_textarea: true
      video_assigned: true

    _enabled: ->
      can('update', @view.options.model)