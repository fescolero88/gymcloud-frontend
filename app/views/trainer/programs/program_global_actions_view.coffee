Marionette = require 'backbone.marionette'

module.exports = class ProgramGlobalActionsView extends Marionette.ItemView

  className: 'gc-program-actions'

  template: require 'templates/trainer/programs/program_global_actions'

  ui:
    addNoteButton: '.gc-program-add-note'

  events:
    'click @ui.addNoteButton': 'triggerAddNote'

  triggerAddNote: ->
    App.commands.execute 'program:note_editor:toggle'



