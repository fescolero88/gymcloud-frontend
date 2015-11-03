define [
  './template'
  'features/workout_exercises/view'
], (
  template
  WorkoutExercisesView
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'gc-workouts-workout-view'

    behaviors:
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
