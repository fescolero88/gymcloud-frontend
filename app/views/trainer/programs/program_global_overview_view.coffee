Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class ProgramGlobalOverviewView extends Marionette.LayoutView

  template: require('templates/trainer/programs/program_global_overview')

  ui:
    privacyButtons: '.privacy-buttons > .btn'
    privacyRadios: '[name="privacy"]'
    deleteProgram: '.gc-program-delete-button'
    programDescriptionEditor: '.gc-program-description-editor'
    programNotesContainer: '.gc-program-note-container'
    programNoteEditor: '.gc-program-note-editor'

  modelEvents:
    sync: 'modelSaved'

  events:
    'change @ui.privacyRadios': 'togglePrivacy'
    'click @ui.deleteProgram': 'deleteProgram'
    'blur @ui.programDescriptionEditor': 'updateDescription'
    'blur @ui.programNoteEditor': 'saveProgramNote'

  togglePrivacy: (ev) ->
    @ui.privacyButtons.removeClass 'active'
    $(ev.currentTarget).parent().addClass 'active'
    isPublic = ev.currentTarget.value == 'true'
    @model.set 'is_public', isPublic
    @model.save()

  templateHelpers: ->
    hasNote: !!@model.get 'notes'

  initialize: ->
    App.commands.setHandler 'program:title:update', @updateName
    App.commands.setHandler 'program:note_editor:toggle', @triggerNoteEditor

  onDestroy: ->
    App.commands.removeHandler 'program:title:update', @updateName
    App.commands.removeHandler 'program:note_editor:toggle', @triggerNoteEditor

  modelSaved: ->
    App.request 'messenger:show',
      message: "Program Updated Successfully"
      type: 'success'

  deleteProgram: ->
    App.request 'base:confirmationalModal',
      title: "Remove program?"
      content: "Are you sure you want to delete this program?"
      confirmBtn: "Remove"
      confirmCallBack: =>
        id = @model.get 'id'
        name = @model.get 'name'
        App.request 'data:delete', 'programs', id
        window.history.back()
        App.request 'messenger:show',
          hideAfter: 5
          message: "Program #{name} deleted."
          type: 'success'

  updateName: (name, cb) =>
    if @model.get('name') != name
      @model.set 'name', name
      @model.save()

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
