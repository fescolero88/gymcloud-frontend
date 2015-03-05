Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class PropertyModalView extends Marionette.ItemView

  template: Templates.trainer.properties.property_modal

  events:
    'submit form': 'submitForm'
    'blur form input': 'validateInput'

  ui:
    propertyModal: '#gc-add-property-modal'
    form: 'form'

  initialize: ->
    @on 'showModal', @showModal

  templateHelpers: ->
    is_edit: @is_edit

  showModal: (data) ->
    @is_edit = data.is_edit
    @model = data.model
    Backbone.Validation.bind @
    @render()
    @ui.propertyModal.modal('show')

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

  submitForm: (ev) ->
    ev.preventDefault()
    formData = @ui.form.serializeObject()
    @model.set formData
    if !@model.is_edit
      @model.set 'position', 1
    if @model.isValid true
      @model.save null,
        success: (model, data) =>
          if data.error
            for name, error_msg of data.error
              $input = @$el.find("input[name=#{name}]")
              $inputGroup = $input.closest('.form-group')
              @switchError error_msg[0], $inputGroup
          else
            if !@is_edit
              App.vent.trigger 'properties:addModel', @model
            @ui.propertyModal.modal('hide')
