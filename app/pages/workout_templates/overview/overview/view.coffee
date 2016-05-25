define [
  './template'
  'features/workout_exercises/view'
], (
  template
  WorkoutExercisesView
) ->

  class WorkoutOverviewView extends Marionette.LayoutView

    key: 'WorkoutOverviewView'

    template: template

    className: 'gc-box-content'

    behaviors: ->
      author_widget: true
      rating_widget: true
      editable_textarea: true
      video_assigned: true
      privacy_toggle: true
      delete_button: true
      regioned:
        views: [
            region: 'workout_exercises'
            klass: WorkoutExercisesView
            options: ->
              model: @model
              collection: @model.exercises
        ]
