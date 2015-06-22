Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

FormValidationBehaviour = require 'views/helpers/form-validation-behaviour'
EWPGlobalModel = require 'models/trainer/global-ewp-model'

module.exports = class AddGlobalEWPModalView extends Marionette.ItemView

  template: Templates.trainer.global_ewp.add_global_ewp_modal

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
    @typeName = data.type
    rootId = App.request "data:#{@typeName}:root"
    @folderId = data.folderId or rootId
    @modal = data.modalEntity
    @initializeModel()
    
  initializeModel: ->
    @model = new EWPGlobalModel
      type: @typeName

    @listenTo @model, 'sync', @onSync
    @listenTo @model, 'error', @onSyncFail

  onRender: =>
    setTimeout ( =>
        @ui.nameInput.focus()
      ), 400

  templateHelpers: ->
    type: @typeName
    typeSingle: @typeName.substring(0, @typeName.length - 1)

  submitForm: (ev) =>
    ev.preventDefault()
    switch @typeName
      when 'exercises'
        data =
          name: @ui.nameInput.val()
          description: ''
          exercise_folder_id: @folderId
      when 'workouts'
        data =
          name: @ui.nameInput.val()
          workout_folder_id: @folderId
      when 'programs'
        data =
          name: @ui.nameInput.val()
          duration_weeks: 0
          duration_days: 0
          program_folder_id: @folderId

    @model.set data
    @model.save()

  onSync: ->
    @ui.nameInput.val('')
    @trigger 'item:added', @model.toJSON()
    # reinitialize model - maybe there is a better way
    @initializeModel()

  onSyncFail: (model, data) ->
    for name, error_msg of data.error
      $input = @$el.find("input[name=#{name}]")
      $inputGroup = $input.closest('.form-group')
      @trigger 'switchError', error_msg[0], $inputGroup
