WorkoutGlobalExercisesView = require 'views/trainer/workouts/workout_global_exercises_view'
WorkoutExercises = require 'collections/workout_exercises'

module.exports = class WorkoutGlobalOverviewView extends Marionette.LayoutView

  template: require('templates/trainer/workouts/workout_global_overview')

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

  templateHelpers: =>
    workout: @model.attributes
    hasNote: !!@model.get 'notes'

  initialize: (data) ->
    @exercisesCollection = new WorkoutExercises
    @exercisesCollection.set @model.get('exercises')

    @exercisesView = new WorkoutGlobalExercisesView
      collection: @exercisesCollection,
      workout: @model

    @listenTo(@model, 'sync', @workoutModelChanged)

    App.vent.on 'workout:notes:add', @showAddNote, @

  onShow: ->
    @exercisesListRegion.show @exercisesView
    @workoutDescriptionAutoHeight()
    @workoutNoteAutoHeight()

  onDestroy: ->
    App.vent.off 'workout:notes:add', @showAddNote

  workoutDescriptionAutoHeight: ->
    workoutDesc = @ui.workoutDescription.get 0
    if workoutDesc.scrollHeight > workoutDesc.clientHeight
      workoutDesc.style.height = "#{workoutDesc.scrollHeight}px"

  workoutNoteAutoHeight: ->
    workoutNote = @ui.workoutNoteEditor.get 0
    if workoutNote.scrollHeight > workoutNote.clientHeight
      workoutNote.style.height = "#{workoutNote.scrollHeight}px"

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

  workoutDescriptionSave: ->
    @model.set 'description', @ui.workoutDescription.val()
    if @model.hasChanged()
      @model.save().success =>
        App.request 'messenger:show',
          hideAfter: 5
          message: "Workout's description saved."
          type: 'success'

  setPrivacy: (e) ->
    @model.set('is_public', e.target.value)
    @model.save().success =>
      App.request 'messenger:show',
        message: 'Privacy settings changed.'

  workoutModelChanged: =>
    @exercisesCollection.set @model.get('exercises')

  showAddNote: ->
    hasNote = !!@model.get('notes')
    if hasNote
      @ui.workoutNoteEditor.addClass 'focus-state'
    else
      @ui.workoutNotesContainer.removeClass 'hidden'
      @ui.workoutNoteEditor.addClass 'focus-state'
    @ui.workoutNoteEditor.focus()

  workoutNoteSave: ->
    note = @ui.workoutNoteEditor.val()
    if @model.get('notes') != note
      @model.set 'notes', note
      @model.save().then =>
        @ui.workoutNoteEditor.removeClass 'focus-state'
        if @model.get('notes') is '' #hide notes ui
          @ui.workoutNotesContainer.addClass 'hidden'
        App.request 'messenger:show',
          message: "Workout's note saved."
          type: 'success'
