Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

FormValidationBehaviour = require 'views/helpers/form-validation-behaviour'

module.exports = class AddGlobalFolderModalView extends Marionette.ItemView

  template: require('templates/trainer/global_ewp/add_global_folder_modal')

  className: 'modal-dialog modal-md'

  behaviors:
    FormValidationBehaviour:
      behaviorClass: FormValidationBehaviour

  ui:
    form: 'form'
    nameInput: '.form-control'

  events:
    'submit @ui.form': 'submitForm'

  initialize: (data) =>
    rootId = App.request "data:#{data.type}:root"
    @folderId = data.folderId or rootId

  submitForm: (ev) =>
    ev.preventDefault()
    data =
      name: @ui.nameInput.val()
      parent_id: @folderId
    $.ajax
      method: 'POST'
      url: '/api/mobile/folders'
      dataType: 'json'
      data: JSON.stringify data
      statusCode:
        201: (model, data) =>
          if data?.error
            for name, error_msg of data.error
              $input = @$el.find("input[name=#{name}]")
              $inputGroup = $input.closest('.form-group')
              @trigger 'switchError', error_msg[0], $inputGroup
          else
            @trigger 'folder:added', model
