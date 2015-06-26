Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

FormValidationBehaviour = require 'views/helpers/form-validation-behaviour'

module.exports = class GroupFormModalView extends Marionette.ItemView

  template: require('templates/trainer/clients/group_form_modal')

  behaviors:
    FormValidationBehaviour:
      behaviorClass: FormValidationBehaviour

  className: 'modal-dialog'

  events:
    'submit @ui.groupForm': 'submitGroupForm'
    'change .gc-edit-profile-modal-upload-input': 'showThumbnail'
    'blur form input': 'validateInput'

  ui:
    groupForm: 'form'

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

  showThumbnail: (ev) ->
    input = ev.target
    if input.files && input.files[0]
      reader = new FileReader()
      reader.onload = (e) ->
        $(ev.target).parents('form').find('.gc-edit-profile-modal-avatar').attr('src', e.target.result)
      reader.readAsDataURL(input.files[0])

  submitGroupForm: (ev) =>
    ev.preventDefault()
    avatar = $(ev.target).find('input[type=file]')
    formData = @ui.groupForm.serializeObject()
    for key, value of formData
      if not value
        delete formData[key]
    @model.set formData
    if @model.isValid true
      App.vent.trigger('spinner:global:start')
      @model.save null,
        success: (model, data) =>
          App.vent.trigger 'spinner:global:stop'
          if data.error
            for name, error_msg of data.error
              $input = @$el.find("input[name=#{name}]")
              $inputGroup = $input.closest('.form-group')
              @trigger 'switchError', error_msg[0], $inputGroup
          else
            @trigger 'closeModal'
            @trigger 'addToGroupsCollection', model
            if avatar[0].files[0]
              data = new FormData()
              data.append('avatar', avatar[0].files[0])
              $.ajax
                url: "#{model.urlRoot}/#{model.id}/avatar"
                type: 'PUT'
                data: data
                cache: false
                dataType: 'json'
                processData: false
                contentType: false
                success: (data) =>
                  model.set 'avatar_url', data.avatar_url
                  @trigger 'avatarChange'
