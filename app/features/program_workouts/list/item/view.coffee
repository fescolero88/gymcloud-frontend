define [
  './template'
  'features/workout_exercises/view'
], (
  template
  WorkoutExercisesView
) ->

  class View extends Marionette.LayoutView

    template: template

    behaviors:

      editable_textarea: true

      stickit:
        bindings:
          '.gc-workout-title > span': 'name'
          'label input': 'is_visible'
          '.gc-description-editor': 'description'

      regioned:
        views: [
            region: 'workout_exercises'
            klass: WorkoutExercisesView
            options: ->
              model: @model.workout
              collection: @model.workout.exercises
        ]
