define [
  'backbone.marionette'
  './counters/view'
  './template'
], (
  Marionette
  CountersView
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

    regions:
      counters: '.col-xs-4'

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
        @model.get('author_id') is App.request('current_user_id')

    initialize: (options) ->
      @workoutsCollection = options.workoutsCollection
      @weekWorkoutsCollection = options.weekWorkoutCollection
      @counters = new CountersView
        weekCollection: @collection
        workoutsCollection: @workoutsCollection
        weekWorkoutsCollection: @weekWorkoutsCollection

      @listenTo(@model, 'note:toggle_editor', @triggerNoteEditor)

    onRender: ->
      @stickit()
      @getRegion('counters').show(@counters)

    onDestroy: ->
      @unstickit()

    triggerNoteEditor: =>
      if !!@model.get('note')
        @ui.programNoteEditor.addClass 'focus-state'
      else
        @ui.programNotesContainer.removeClass 'hidden'
        @ui.programNoteEditor.removeClass 'focus-state'
      @ui.programNoteEditor.focus()

    _saveOnChange: (_model, _value) ->
      @model.save()