define [
  './template'
], (
  template
) ->

  class ExerciseOverviewView extends Marionette.LayoutView

    template: template

    behaviors:
      privacy_toggle: true
      delete_button: true
      author_widget: true
      rating_widget: true
      editable_textarea: true
      video_assigned: true
