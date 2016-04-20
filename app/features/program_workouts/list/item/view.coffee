define [
  './template'
  'features/workout_exercises/view'
], (
  template
  WorkoutExercisesView
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'gc-program-workout-item'

    behaviors:

      editable_textarea:
        model: ->
          @view.model.workout
      video_assigned:
        model: ->
          @view.model.workout

      stickit:
        model: ->
          @model.workout
        bindings:
          ':el':
            attributes: [
                observe: 'id'
                name: 'data-id'
                onGet: -> @model.get('id')
            ]
          '.gc-workout-title > span':
            observe: 'name'
            events: ['blur']
          'label input': 'is_visible'

      regioned:
        views: [
            region: 'workout_exercises'
            klass: WorkoutExercisesView
            options: ->
              model: @model.workout
              collection: @model.workout.exercises
        ]

    ui:
      workoutTabsContent: '.gc-workout-tab-content'

    events:
      'click .gc-delete-program-workout': '_destroy'
      'click a[data-action="save_in_library"]': '_saveInLibrary'
      'click ul.gc-content-nav li a': '_changeTab'

    triggers:
      'click a[data-action="duplicate"]': 'duplicate:program_workout'

    initialize: ->
      @listenTo(App.vent, 'dropped:to:week', @_updateWeekId)
      @listenTo(@model.workout, 'change:name', @_patchWorkout)

    onShow: ->
      @listenToOnce @video_assigned, 'show', ->
        @listenTo @video_assigned.currentView, 'video:assign', @_openUploadPopup

    _destroy: ->
      App.request('modal:confirm:delete', @model)

    _saveInLibrary: ->
      user = App.request('current_user')
      workoutTemplatesFolder = user.getRootFolderFor('Workout Templates')
      folderItems = workoutTemplatesFolder.items
      id = if @model.get('program_type') is 'ProgramTemplate'
        @model.workout.get('id')
      else
        @model.workout.get('workout_template_id')
      folderItems.duplicate(
        ids: [id]
        foldersIds: [workoutTemplatesFolder.get('id')]
      ).then ->
        App.request('messenger:explain', 'program_workout.saved')

    _changeTab: (ev) ->
      tabName = $(ev.currentTarget).data('content')
      @ui.workoutTabsContent.find('.tab-pane.active').removeClass('active')
      @ui.workoutTabsContent.find("[data-pane='#{tabName}']").addClass('active')

    _openUploadPopup: ->
      view = App.request('base:uploadVideo')
      @listenToOnce(view, 'videoUploaded', @_videoUploaded)
      @listenToOnce(view, 'onDestroy', -> @stopListening(view))

    _videoUploaded: (model) ->
      @model.workout.save
        video_url: model.get('embed_url')
        video_id: model.get('id')
      , wait: true

    _updateWeekId: (el, weekId) ->
      if el is @el
        @model.set(week_id: weekId)
        @model.patch()

    _patchWorkout: ->
      @model.workout.patch()
