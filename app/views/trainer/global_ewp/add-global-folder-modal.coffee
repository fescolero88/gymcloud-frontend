Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

GlobalFolderModel = require 'models/trainer/global-folder-model'

FormValidationBehaviour = require 'views/helpers/form-validation-behaviour'

module.exports = class AddGlobalFolderModalView extends Marionette.ItemView

  template: Templates.trainer.global_ewp.add_global_folder_modal

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
    console.log 'add folder view init'
    rootId = App.request "data:#{data.type}:root"
    @folderId = data.folderId or rootId
    @initializeModel()

  initializeModel: ->
    @model = new GlobalFolderModel()
    @listenTo @model, 'sync', @onSync
    @listenTo @model, 'error', @onSyncFail

  submitForm: (ev) =>
    ev.preventDefault()
    data =
      name: @ui.nameInput.val()
      parent_id: @folderId

    @model.set data
    @model.save()

  onSync: (model) ->
    @trigger 'folder:added', model.toJSON()
    @ui.nameInput.val('')
    @initializeModel()
