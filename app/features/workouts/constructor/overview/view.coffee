define [
  './exercises/view'
  'collections/workout_exercises'
  'features/privacy_buttons/view'
  './template'
], (
  WorkoutExercisesView
  WorkoutExercises
  PrivacyButtons
  template
) ->
  class WorkoutOverviewView extends Marionette.LayoutView

    template: template

    className: 'gc-workouts-workout-view'

    regions:
      privacyButtons: 'region[data-name="privacy-buttons"]'
      exercisesList: '#gc-exercises-list-region'

    ui:
      workoutDescription: '.gc-workout-description-editor'
      workoutExerciseAddButton: '.gc-workout-add-exercise-button'
      workoutDeleteButton: '.gc-workout-delete-button'
      workoutVideoDeleteButton: '.gc-workout-video-delete'
      workoutNotesContainer: '.gc-workout-note-container'
      workoutNoteEditor: '.gc-workout-note-editor'
      iframe: 'iframe'
      player: '.gc-workout-video'

    events:
      'keyup @ui.workoutDescription': 'workoutDescriptionAutoHeight'
      'keyup @ui.workoutNoteEditor': 'workoutNoteAutoHeight'
      'click @ui.workoutExerciseAddButton': 'workoutExerciseAdd'
      'click @ui.workoutDeleteButton': 'workoutDelete'
      'click @ui.workoutVideoDeleteButton': '_deleteVideo'
      'blur @ui.workoutDescription': '_saveAttribute'
      'blur @ui.workoutNoteEditor': '_saveAttribute'

    behaviors:

      stickit:
        bindings:
          '[data-bind="description"]': 'description'
          '[data-bind="note"]': 'note'
          '[data-bind="is_public"]': 'is_public'

    modelEvents:
      'change:video_url': '_togglePlayer'

    templateHelpers: =>
      isAuthor: @_isAuthor()
      hasNote: !!@model.get('note')
      videoType: @_getVideoType()

    initialize: (data) ->
      @originalModel = new Backbone.Model(@model.attributes)
      @privacyButtons = new PrivacyButtons(model: @model)
      @exercisesView = new WorkoutExercisesView
        collection: @model.exercises,
        workout: @model

      App.vent.on 'workout:notes:add', @showAddNote, @

    onShow: ->
      @getRegion('privacyButtons').show(@privacyButtons) if @_isAuthor()
      @getRegion('exercisesList').show(@exercisesView)
      @workoutDescriptionAutoHeight()
      @workoutNoteAutoHeight()

    onDestroy: ->
      App.vent.off 'workout:notes:add', @showAddNote

    workoutDescriptionAutoHeight: ->
      @_textAreaAutoHeight('workoutDescription')

    workoutNoteAutoHeight: ->
      @_textAreaAutoHeight('workoutNoteEditor')

    workoutExerciseAdd: (e) ->
      e.preventDefault()

    workoutDelete: ->
      App.request 'base:confirmationalModal',
        title: 'Delete workout'
        content: "Are you sure you want to delete #{@model.get('name')}?"
        confirmBtn: 'Delete'
        confirmCallBack: => @model.destroy()

    showAddNote: ->
      @ui.workoutNotesContainer.removeClass('hidden') if !@model.get('notes')
      @ui.workoutNoteEditor.focus()

    _isAuthor: ->
      @model.get('author_id') == App.request('current_user_id')

    _textAreaAutoHeight: (area) ->
      el = @ui[area]?.get(0)
      if el?.scrollHeight > el?.clientHeight
        el.style.height = "#{el.scrollHeight}px"

    _saveAttribute: (ev) ->
      $el = $(ev.currentTarget)
      attribute = $el.data('bind')
      return ev if @originalModel.get(attribute) is @model.get(attribute)

      @model.save()
        .then( (response) => @originalModel.set(response) )
        .fail( => @model.set(@originalModel.attributes) )

    _togglePlayer: ->
      if @model.get('video_url')
        @ui.player.removeClass('hidden')
        @ui.iframe.attr('src', @model.get('video_url'))
      else
        @ui.player.addClass('hidden')

    _deleteVideo: ->
      App.request 'base:confirmationalModal',
        title: 'Remove workout video?'
        content: 'Are you sure you want to remove this video from workout?'
        confirmBtn: 'Remove'
        confirmCallBack: =>
          @model.save({video_url: null, video_id: null}, wait: true)

    _getVideoType: ->
      url = @model.get('video_url')
      return unless _.any(url)
      url.indexOf('vimeo') isnt -1 && 'vimeo' || 'youtube'