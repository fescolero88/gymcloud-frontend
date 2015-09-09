FormValidationBehaviour = require 'views/helpers/form-validation-behaviour'

module.exports = class ClientFormModalView extends Marionette.ItemView

  template: require('templates/trainer/clients/client-form-modal')

  className: 'modal-dialog'

  behaviors:
    FormValidationBehaviour:
      behaviorClass: FormValidationBehaviour

  events:
    'submit @ui.clientForm': 'submitClientForm'
    'change .gc-edit-profile-modal-upload-input': 'showThumbnail'
    'blur form input': 'validateInput'

  modelEvents:
    'sync': 'onSync'
    'error': 'onSyncError'
    'model:avatar_update:success': 'onAvatarUpdate'

  ui:
    clientForm: 'form'

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

  submitClientForm: (ev) =>
    ev.preventDefault()
    @avatar = $(ev.target).find('input[type=file]')
    formData = @ui.clientForm.serializeObject()
    for key, value of formData
      if key in ['weight, height, bodyfat']
        formData[key] = value.replace(/\,/g,'.')
      if key is 'gender'
        formData[key] = parseInt value
      if not value
        delete formData[key]
    @model.set formData
    @model.set 'account_type', 3

    if @model.isValid true
      @model.save()

  onSync: (model, response, options) ->
    @trigger 'modal:close'
    @trigger 'addToClientsCollection', model
    if @avatar[0].files[0]
      data = new FormData()
      data.append('avatar', @avatar[0].files[0])
      @model.updateAvatar(data)

  onAvatarUpdate: (response) ->
    @model.set 'avatar_url', data.avatar_url
    @trigger 'avatarChange'

  onSyncError: (model, response, options) ->
    #todo implement sync error


