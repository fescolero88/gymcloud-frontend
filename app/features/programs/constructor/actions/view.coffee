define [
  'backbone.marionette'
  './template'
], (
  Marionette
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
      App.request 'base:confirmationalModal',
        title: "Remove program?"
        content: "Are you sure you want to delete this program?"
        confirmBtn: "Remove"
        confirmCallBack: =>
          @model.destroy()