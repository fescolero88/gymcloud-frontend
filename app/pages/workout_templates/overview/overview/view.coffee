define [
  './template'
  'features/workout_exercises/view'
  'features/personal_workout_exercises/view'
], (
  template
  WorkoutExercisesView
  ReadableWorkoutExercisesView
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
      privacy_toggle:
        enabled: @_enabled
      delete_button:
        enabled: @_enabled

    regions:
      workout_exercises: 'region[data-name="workout_exercises"]'

    _enabled: ->
      can('update', @view.options.model)

    initialize: ->
      @listenTo(@model, 'sync', @_renderWorkoutExercises)

    _renderWorkoutExercises: ->
      View = if can('update', @model)
        WorkoutExercisesView
      else
        ReadableWorkoutExercisesView
      view = new View
        model: @model
        collection: @model.exercises
      region = @getRegion('workout_exercises')
      region.show(view)
