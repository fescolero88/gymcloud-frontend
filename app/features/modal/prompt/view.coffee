define [
  './template'
], (
  template
) ->

  class ModalPromptView extends Marionette.ItemView

    template: template

    className: 'modal-dialog modal-md'

    ui:
      confirmButton: '.confirm'
      cancelButton: '.cancel'
      modal: '.modal'

    events:
      'click @ui.confirmButton': 'confirmEvent'
      'click @ui.cancelButton': 'cancelEvent'
      'hidden.bs.modal @ui.modal': 'onModalClosed'

    behaviors:
      stickit:
        bindings:
          '.title': 'title'
          'input': 'prompt'
          '.gc-rm-buttons .confirm': 'confirmBtn'

    initialize: (data)->
      @model = new Backbone.Model
      @model.set(data)

    confirmEvent: ->
      str = _.trim @model.get('prompt')
      @model.get('confirmCallBack')?(str)

    cancelEvent: ->
      @model.get('cancelCallBack')?()

    onModalClosed: ->
      @trigger 'modal:closed'
