Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class AddGlobalEWPModalView extends Marionette.ItemView
  className: 'modal-dialog modal-md'
  template: Templates.trainer.global_ewp.add_global_ewp_modal

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

  onShow: =>
    @modal.on 'shown.bs.modal', (ev) =>
      ev.preventDefault()
      @ui.nameInput.focus()

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

    $.ajax
      method: 'POST'
      url: "/api/mobile/#{@typeName}"
      dataType: 'json'
      data: JSON.stringify data
      statusCode:
        201: (model, data) =>
          if data?.error
            for name, error_msg of data.error
              $input = @$el.find("input[name=#{name}]")
              $inputGroup = $input.closest('.form-group')
              @switchError error_msg[0], $inputGroup
          else
            @ui.nameInput.val('')
            @trigger 'item:added', model
