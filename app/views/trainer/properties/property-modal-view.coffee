FormValidationBehaviour = require 'views/helpers/form-validation-behaviour'

module.exports = class PropertyModalView extends Marionette.ItemView

  template: require('templates/trainer/properties/property-modal')

  behaviors:
    FormValidationBehaviour:
      behaviorClass: FormValidationBehaviour

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
      @trigger 'switchError', error_msg, $inputGroup

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
              @trigger 'switchError', error_msg[0], $inputGroup
          else
            if !@is_edit
              App.vent.trigger 'properties:addModel', @model
            @ui.propertyModal.modal('hide')
