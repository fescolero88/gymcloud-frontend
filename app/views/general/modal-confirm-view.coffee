Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class ModalConfirmView extends Marionette.ItemView

  template: require('templates/general/modal-confirm')

  ui:
    confirmButton: '.confirm'
    cancelButton: '.cancel'
    modal: ".modal"

  events:
    "click @ui.confirmButton": "confirmEvent"
    "click @ui.cancelButton": "cancelEvent"
    "hidden.bs.modal @ui.modal": "closeModal"

  initialize: (data)->
    @confirmData = data

  templateHelpers: ->
    title: @confirmData.title
    content: @confirmData.content
    confirmBtn: @confirmData.confirmBtn

  confirmEvent: (ev) ->
    ev.preventDefault()
    if @confirmData.confirmCallBack?
      @confirmData.confirmCallBack()

  cancelEvent: (ev) ->
    ev.preventDefault()
    if @confirmData.cancelCallBack?
      @confirmData.cancelCallBack()

  closeModal: ->
    @trigger "modal:closed"
