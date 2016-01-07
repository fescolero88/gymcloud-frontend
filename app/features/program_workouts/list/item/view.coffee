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

    events:
      'click .gc-delete-program-workout': '_destroy'
      'click a[data-action="save_in_library"]': '_saveInLibrary'

    triggers:
      'click a[data-action="duplicate"]': 'duplicate:program_workout'

    _destroy: (ev) ->
      ev.preventDefault()
      App.request('modal:confirm:delete', @model)

    _saveInLibrary: (ev) ->
      ev.preventDefault()
      user = App.request('current_user')
      workoutTemplatesFolder = user.getRootFolderFor('Workouts')
      folderItems = workoutTemplatesFolder.items
      folderItems.duplicate(
        ids: [@model.workout.get('id')]
        foldersIds: [workoutTemplatesFolder.get('id')]
      ).then ->
        App.request('messenger:explain', 'program_workout.saved')
