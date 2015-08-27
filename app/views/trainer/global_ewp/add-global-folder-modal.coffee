Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

GlobalFolder = require 'models/global_folder'

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
    @initializeModel()

  initializeModel: ->
    @model = new GlobalFolder
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
