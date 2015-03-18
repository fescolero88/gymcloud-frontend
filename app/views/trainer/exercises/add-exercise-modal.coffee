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
    @folderId = data.folderId or 0

  submitForm: (ev) =>
    ev.preventDefault()
    data =
      name: @ui.nameInput.val()
      description: ''
      exercise_folder_id: @folderId
    console.debug data
    $.ajax
      method: 'POST'
      url: '/api/mobile/exercises'
      dataType: 'json'
      data: JSON.stringify data
      success: (data) =>
        console.debug data
