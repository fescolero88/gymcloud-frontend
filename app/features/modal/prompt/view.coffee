define [
  './template'
], (
  template
) ->

  class ModalConfirmView extends Marionette.ItemView

    template: template

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
          '.modal-body p': 'content'
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
