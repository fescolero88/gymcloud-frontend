define [
  './template'
], (
  template
) ->

  class ExerciseOverviewView extends Marionette.LayoutView

    template: template

    className: 'gc-box-content'

    behaviors:
      author_widget: true
      editable_textarea: true
      video_assigned: true
