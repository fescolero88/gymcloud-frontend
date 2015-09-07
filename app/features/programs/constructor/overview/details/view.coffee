define [
  'backbone.marionette'
  './template'
], (
  Marionette
  template
) ->

  # TODO: LayoutView?
  class DetailsView extends Marionette.LayoutView

    className: 'row gc-remove-margin'

    template: template

    ui:
      programDescriptionEditor: '.gc-program-description-editor'
      programNotesContainer: '.gc-program-note-container'
      programNoteEditor: '.gc-program-note-editor'
      programWeeksCount: '.gc-program-weeks-count'
      programWorkoutCount: '.gc-program-workout-count'

    bindings:
      '[data-bind="description"]':
        observe: 'description'
        events: ['change']
      '[data-bind="note"]':
        observe: 'note'
        events: ['change']

    modelEvents:
      'change:name': '_saveOnChange'
      'change:description': '_saveOnChange'

    templateHelpers: =>
      hasNote: !!@model.get('note')
      weeksCount: @collection.length
      workoutCount: @workoutsCollection.length
      isAuthor: do =>
        App.request('current_user_id') is @model.get('author_id')

    initialize: (options) ->
      @workoutsCollection = options.workoutsCollection
      @weekWorkoutCollection = options.weekWorkoutCollection

      @listenTo(@model, 'note:toggle_editor', @triggerNoteEditor)
      @listenTo(@collection, 'update', @weeksUpdated)
      @listenTo(@workoutsCollection, 'update', @workoutsUpdated)

    onRender: ->
      @stickit()

    onDestroy: ->
      @unstickit()

    triggerNoteEditor: =>
      if !!@model.get('note')
        @ui.programNoteEditor.addClass 'focus-state'
      else
        @ui.programNotesContainer.removeClass 'hidden'
        @ui.programNoteEditor.removeClass 'focus-state'
      @ui.programNoteEditor.focus()

    weeksUpdated: ->
      @ui.programWeeksCount.html(@collection.length)

    workoutsUpdated: ->
      count = @weekWorkoutCollection.length + @workoutsCollection.length
      @ui.programWorkoutCount.html(count)

    _saveOnChange: (_model, _value) ->
      @model.save()