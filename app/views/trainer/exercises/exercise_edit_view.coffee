Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

module.exports = class ExerciseEditView extends Marionette.ItemView
  template: Templates.trainer.exercises.exercise_edit

  modelEvents:
    sync: 'render'

  ui:
    form: 'form'
    backButton: '.gc-exercise-back-button'

  events:
    'submit @ui.form': 'submitForm'
    'click @ui.backButton': 'back'
    'blur form input': 'validateInput'
    'blur form textarea': 'validateInput'

  initialize: =>
    Backbone.Validation.bind @

  validateInput: (ev) ->
    $input = $(ev.target)
    input_name = $(ev.target).attr 'name'
    input_value = $(ev.target).val()
    if input_value
      $inputGroup = $input.closest('.form-group')
      error_msg = @model.preValidate input_name, input_value
      @switchError error_msg, $inputGroup

  switchError: (error_msg, $inputGroup) =>
    if error_msg
      $inputGroup.removeClass('gc-valid').addClass('gc-invalid')
      $inputGroup.find('.gc-valid-icon').addClass('hide')
      $inputGroup.find('.gc-error-message').text(error_msg)
    else
      $inputGroup.removeClass('gc-invalid').addClass('gc-valid')
      $inputGroup.find('.gc-valid-icon').removeClass('hide')
      $inputGroup.find('.gc-error-message').text('')

  submitForm: (e) =>
    e.preventDefault()
    formData = @ui.form.serializeObject()
    @model.set formData
    if @model.isValid true
      @model.save null,
        success: =>
          @trigger 'exercise:back'
          App.request 'messenger:show',
            hideAfter: 5
            message: "Item was edited."
            type: 'success'
        error: (e, data) =>
          for name, error_msg of data.responseJSON.message
            $input = @$el.find("input[name=#{name}]")
            $inputGroup = $input.closest('.form-group')
            @switchError error_msg[0], $inputGroup

  back: (e) =>
    e.preventDefault()
    @model.set @model.previousAttributes()
    @trigger 'exercise:back'

  onDestroy: =>
    Backbone.Validation.unbind @
