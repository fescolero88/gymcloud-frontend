# FIXME: to remove

define [
  './template'
], (
  template
) ->

  class WorkoutOverviewView extends Marionette.LayoutView

    template: template

    className: 'gc-workouts-workout-view'

    regions:
      exercisesList: '#gc-exercises-list-region'

    ui:
      workoutExerciseAddButton: '.gc-workout-add-exercise-button'
      workoutDeleteButton: '.gc-workout-delete-button'
      workoutNotesContainer: '.gc-workout-note-container'
      iframe: 'iframe'
      player: '.gc-workout-video'

    events:
      'click @ui.workoutExerciseAddButton': 'workoutExerciseAdd'
      'click @ui.workoutDeleteButton': 'workoutDelete'

    behaviors:

      privacy_toggle: true

    templateHelpers: =>
      author: @model.author.toJSON()
      isAuthor: @_isAuthor()
      isMine: @_isMine()
      hasNote: !!@model.get('note')
      canAddToLibrary: do =>
        !@_isMine() && !@_isAuthor() && @model.get('is_public')

    initialize: (data) ->
      App.vent.on 'workout:notes:add', @showAddNote, @

    onDestroy: ->
      App.vent.off 'workout:notes:add', @showAddNote

    workoutExerciseAdd: (e) ->
      e.preventDefault()

    workoutDelete: ->
      App.request('modal:confirm:delete', @model)

    showAddNote: ->
      @ui.workoutNotesContainer.removeClass('hidden') if !@model.get('notes')
      @ui.workoutNoteEditor.focus()

    _isAuthor: ->
      @model.get('author_id') == App.request('current_user_id')

    _isMine: ->
      @model.get('user_id') == App.request('current_user_id')
