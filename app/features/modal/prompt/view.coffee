define [
  './template'
  './model'
], (
  template
  PromptModel
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
      'keyup input': '_validateInput'

    behaviors:

      form_validation: true

      stickit:
        bindings:
          '.title': 'title'
          'input': 'prompt'
          '.gc-rm-buttons .confirm': 'confirmBtn'

    initialize: (data)->
      @model = new PromptModel(data)
      Backbone.Validation.bind(@)

    confirmEvent: ->
      str = _.trim @model.get('prompt')
      @model.set('prompt', str)
      return false unless @_isValid()

      @model.get('confirmCallBack')?(str)

    cancelEvent: ->
      @model.get('cancelCallBack')?()

    onModalClosed: ->
      @trigger 'modal:closed'

    _validateInput: (ev) ->
      @_isValid()
      ev

    _isValid: ->
      $inputGroup = @$('.form-group')
      value = @model.get('prompt')
      errorMsg = @model.preValidate('prompt', value)
      @trigger('switchError', errorMsg, $inputGroup)
      !errorMsg
