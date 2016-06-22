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

    className: 'gc-box-content workout-template overview'

    behaviors: ->
      author_widget: true
      privacy_button: true
      add_to_library: true
      video_preview: true

      stickit:
        bindings:
          '.description': 'description'
          '.btn.edit':
            observe: 'author_id'
            visible: ->
              can('update', @model)
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: (id) ->
                  "#workout_templates/#{id}/edit"
            ]

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
