Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

FormValidationBehaviour = require 'views/helpers/form-validation-behaviour'

module.exports = class ExerciseEditView extends Marionette.ItemView

  template: Templates.trainer.exercises.exercise_edit

  behaviors:
    FormValidationBehaviour:
      behaviorClass: FormValidationBehaviour

  modelEvents:
    sync: 'onSync'
    error: 'onSyncFail'

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
      @trigger 'switchError', error_msg, $inputGroup

  submitForm: (e) =>
    e.preventDefault()
    formData = @ui.form.serializeObject()
    @model.set formData
    if @model.isValid true
      @model.save()
     
  onSync: ->
    @trigger 'exercise:back'
    App.request 'messenger:show',
      hideAfter: 5
      message: "Item was edited."
      type: 'success'

  onSyncFail: (model, xhr, options) ->
    for name, error_msg of xhr.responseJSON.message
      $input = @$el.find("input[name=#{name}]")
      $inputGroup = $input.closest('.form-group')
      @trigger 'switchError', error_msg[0], $inputGroup

  back: (e) =>
    e.preventDefault()
    @model.set @model.previousAttributes()
    @trigger 'exercise:back'

  onDestroy: =>
    Backbone.Validation.unbind @
