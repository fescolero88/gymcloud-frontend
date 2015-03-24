Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class AddExerciseModalView extends Marionette.ItemView
  className: 'modal-dialog modal-md'
  template: Templates.trainer.exercises.add_exercise_modal

  ui:
    form: 'form'
    nameInput: '.form-control'

  events:
    'submit @ui.form': 'submitForm'

  initialize: (data) =>
    exercisesRootId = App.request 'data:exercises:root'
    @folderId = data.folderId or exercisesRootId

  submitForm: (ev) =>
    ev.preventDefault()
    data =
      name: @ui.nameInput.val()
      description: ''
      exercise_folder_id: @folderId
    $.ajax
      method: 'POST'
      url: '/api/mobile/exercises'
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
            @trigger 'exercise:added', model
