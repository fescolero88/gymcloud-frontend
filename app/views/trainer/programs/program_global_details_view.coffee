Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class ProgramGlobalDetailsView extends Marionette.LayoutView

  template: require('templates/trainer/programs/program_global_details')

  templateHelpers: ->
    hasNote: !!@model.get 'notes'

  ui:
    programDescriptionEditor: '.gc-program-description-editor'
    programNotesContainer: '.gc-program-note-container'
    programNoteEditor: '.gc-program-note-editor'

  initialize: ->
    App.commands.setHandler 'program:title:update', @updateName
    App.commands.setHandler 'program:note_editor:toggle', @triggerNoteEditor

  onDestroy: ->
    App.commands.removeHandler 'program:title:update', @updateName
    App.commands.removeHandler 'program:note_editor:toggle', @triggerNoteEditor

  events:
    'blur @ui.programDescriptionEditor': 'updateDescription'
    'blur @ui.programNoteEditor': 'saveProgramNote'

  updateName: (name, cb) =>
    if @model.get('name') != name
      @model.set 'name', name
      @model.save().then =>
        App.vent.trigger 'ewp:model:updated', 'programs', @model.get('id'), @model.get('name')

  updateDescription: ->
    if @model.get('description') != @ui.programDescriptionEditor.val()
      @model.set 'description', @ui.programDescriptionEditor.val()
      @model.save()

  triggerNoteEditor: =>
    hasNote = !!@model.get('notes')
    if hasNote
      @ui.programNoteEditor.addClass 'focus-state'
    else
      @ui.programNotesContainer.removeClass 'hidden'
      @ui.programNoteEditor.removeClass 'focus-state'
    @ui.programNoteEditor.focus()

  saveProgramNote: ->
    note = @ui.programNoteEditor.val()
    if @model.get('notes') != note
      @model.set 'notes', note
      @model.save().success =>
        @ui.programNoteEditor.removeClass 'focus-state'
        if @model.get('notes') is '' #hide notes ui
          @ui.programNotesContainer.addClass 'hidden'

        App.request 'messenger:snow',
          message: "Workout's note saved."
