define [
  './template'
], (
  template
) ->

  class ActionsView extends Marionette.ItemView

    className: 'gc-program-actions'

    template: template

    ui:
      addNoteButton: '.gc-program-add-note'
      deleteProgram: '.gc-program-delete'

    events:
      'click @ui.addNoteButton': 'triggerAddNote'
      'click @ui.deleteProgram': 'deleteProgram'

    triggerAddNote: ->
      @model.trigger('note:toggle_editor')

    deleteProgram: ->
      App.request('modal:confirm:delete', @model)
