define [
  'backbone.marionette'
  './exercises/view'
  'collections/workout_exercises'
  './template'
], (
  Marionette
  WorkoutExercisesView
  WorkoutExercises
  template
) ->
  class WorkoutOverviewView extends Marionette.LayoutView

    template: template

    className: 'gc-workouts-workout-view'

    regions:
      exercisesListRegion: '#gc-exercises-list-region'

    ui:
      workoutDescription: '.gc-workout-description-editor'
      workoutExerciseAddButton: '.gc-workout-add-exercise-button'
      workoutDeleteButton: '.gc-workout-delete-button'
      workoutPrivacyControls: 'input[name="privacy"]'
      workoutNotesContainer: '.gc-workout-note-container'
      workoutNoteEditor: '.gc-workout-note-editor'

    events:
      'keyup @ui.workoutDescription': 'workoutDescriptionAutoHeight'
      'keyup @ui.workoutNoteEditor': 'workoutNoteAutoHeight'
      'click @ui.workoutExerciseAddButton': 'workoutExerciseAdd'
      'click @ui.workoutDeleteButton': 'workoutDelete'
      'blur @ui.workoutDescription': 'workoutDescriptionSave'
      'blur @ui.workoutNoteEditor': 'workoutNoteSave'
      'change @ui.workoutPrivacyControls': 'setPrivacy'

    bindings:
      '[data-bind="description"]': 'description'
      '[data-bind="note"]': 'note'
      '[data-bind="is_public"]': 'is_public'

    templateHelpers: =>
      currentUserId: App.request('current_user_id')
      workout: @model.attributes
      hasNote: !!@model.get 'notes'

    initialize: (data) ->
      @exercisesView = new WorkoutExercisesView
        collection: @model.exercises,
        workout: @model

      App.vent.on 'workout:notes:add', @showAddNote, @

    onShow: ->
      @stickit(@model)
      @exercisesListRegion.show @exercisesView
      @workoutDescriptionAutoHeight()
      @workoutNoteAutoHeight()

    onDestroy: ->
      @unstickit()
      App.vent.off 'workout:notes:add', @showAddNote

    workoutDescriptionAutoHeight: ->
      @_textAreaAutoHeight('workoutDescription')

    workoutNoteAutoHeight: ->
      @_textAreaAutoHeight('workoutNoteEditor')

    workoutDescriptionSave: ->
      @_saveAttribute('description')

    setPrivacy: (e) ->
      @_saveAttribute('is_public', 'Privacy settings changed.')

    workoutNoteSave: ->
      @_saveAttribute('note')

    workoutExerciseAdd: (e) ->
      e.preventDefault()

    workoutDelete: ->
      workoutId = @model.get 'id'
      workoutName = @model.get 'name'
      App.request 'base:confirmationalModal',
        title: 'Delete workout'
        content: "Are you sure you want to delete #{workoutName}?"
        confirmBtn: 'Delete'
        confirmCallBack: =>
          @model.destroy().success =>
            App.request 'data:delete', 'workouts', workoutId

            rootId = App.request "data:workouts:root"
            folderId = @model.get 'folder_id'
            @model.set 'key', @model.get('id')
            if folderId and folderId isnt 0 and folderId isnt rootId
              App.vent.trigger "workouts:folder:#{folderId}:model:removed", @model
            else
              App.vent.trigger "workouts:model:removed", @model

            window.history.back()
            App.request 'messenger:show',
              hideAfter: 5
              message: "Workout #{workoutName} deleted."
              type: 'success'

    showAddNote: ->
      hasNote = !!@model.get('note')
      if hasNote
        @ui.workoutNoteEditor.addClass 'focus-state'
      else
        @ui.workoutNotesContainer.removeClass 'hidden'
        @ui.workoutNoteEditor.addClass 'focus-state'
      @ui.workoutNoteEditor.focus()

    _textAreaAutoHeight: (area) ->
      el = @ui[area].get 0
      if el.scrollHeight > el.clientHeight
        el.style.height = "#{el.scrollHeight}px"

    _saveAttribute: (attribute, message) ->
      message = message || "Workout's #{attribute} saved."
      @model.save().success ->
        App.request 'messenger:show',
          hideAfter: 5
          message: message
          type: 'success'
