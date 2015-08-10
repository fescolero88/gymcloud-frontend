Marionette = require 'backbone.marionette'

module.exports = class ProgramGlobalActionsView extends Marionette.ItemView

  className: 'gc-program-actions'

  template: require 'templates/trainer/programs/program_global_actions'

  ui:
    addNoteButton: '.gc-program-add-note'
    deleteProgram: '.gc-program-delete'

  events:
    'click @ui.addNoteButton': 'triggerAddNote'
    'click @ui.deleteProgram': 'deleteProgram'

  triggerAddNote: ->
    App.commands.execute 'program:note_editor:toggle'

  deleteProgram: ->
    App.request 'base:confirmationalModal',
      title: "Remove program?"
      content: "Are you sure you want to delete this program?"
      confirmBtn: "Remove"
      confirmCallBack: =>
        @model.destroy()