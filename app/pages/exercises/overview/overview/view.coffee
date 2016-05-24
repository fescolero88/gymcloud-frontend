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
      privacy_toggle: true
      delete_button: true
      author_widget: true
      rating_widget: true
      editable_textarea: true
      video_assigned: true
