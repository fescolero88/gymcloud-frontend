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

    events:
      'blur @ui.programDescriptionEditor': 'saveModel'
      'blur @ui.programNoteEditor': 'saveModel'

    bindings:
      '[data-bind="description"]':
        observe: 'description'
        events: ['change']
      '[data-bind="note"]':
        observe: 'note'
        events: ['change']

    templateHelpers: =>
      hasNote: !!@model.get('note')
      weeksCount: @collection.length
      workoutCount: @workoutsCollection.length
      isAuthor: do =>
        App.request('current_user_id') is @model.get('author_id')

    initialize: (options) ->
      window.model = @model
      @workoutsCollection = options.workoutsCollection
      @weekWorkoutCollection = options.weekWorkoutCollection
      App.commands.setHandler 'program:note_editor:toggle', @triggerNoteEditor

      @listenTo @collection, 'update', @weeksUpdated
      @listenTo @workoutsCollection, 'update', @workoutsUpdated

    onRender: ->
      @stickit()

    onDestroy: ->
      @unstickit()
      App.commands.removeHandler 'program:note_editor:toggle', @triggerNoteEditor

    saveModel: ->
      keys = _.keys(@model.changed)
      if _.includes(keys, "description") or _.includes(keys, "note")
        @model.save()

    triggerNoteEditor: =>
      if !!@model.get('note')
        @ui.programNoteEditor.addClass 'focus-state'
      else
        @ui.programNotesContainer.removeClass 'hidden'
        @ui.programNoteEditor.removeClass 'focus-state'
      @ui.programNoteEditor.focus()

    weeksUpdated: ->
      @ui.programWeeksCount.html @collection.length

    workoutsUpdated: ->
      count = @weekWorkoutCollection.length + @workoutsCollection.length
      @ui.programWorkoutCount.html count
