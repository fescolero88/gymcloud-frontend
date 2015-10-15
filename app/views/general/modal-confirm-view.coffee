module.exports = class ModalConfirmView extends Marionette.ItemView

  template: require('templates/general/modal-confirm')

  ui:
    confirmButton: '.confirm'
    cancelButton: '.cancel'
    modal: '.modal'

  events:
    'click @ui.confirmButton': 'confirmEvent'
    'click @ui.cancelButton': 'cancelEvent'
    'hidden.bs.modal @ui.modal': 'onModalClosed'

  initialize: (data)->
    @confirmData = data

  templateHelpers: ->
    title: @confirmData.title
    content: @confirmData.content
    confirmBtn: @confirmData.confirmBtn

  confirmEvent: (ev) ->
    if @confirmData.confirmCallBack?
      @confirmData.confirmCallBack()

  cancelEvent: (ev) ->
    if @confirmData.cancelCallBack?
      @confirmData.cancelCallBack()

  onModalClosed: ->
    @trigger 'modal:closed'
