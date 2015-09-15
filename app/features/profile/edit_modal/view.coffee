define [
  './template'
], (
  template
) ->
  class ProfileEditModalView extends Marionette.ItemView

    template: template

    className: 'modal-dialog'

    behaviors:

      form_validation: true

      stickit:
        bindings:
          'input[name="gender"]': 'gender'
          'input[name="weight"]': 'weight'
          'input[name="height"]': 'height'
          'input[name="bodyfat"]': 'bodyfat'
          'input[name="first_name"]': 'first_name'
          'input[name="last_name"]': 'last_name'
          'input[name="location"]': 'location'
          'input[name="zip"]': 'zip'
          'input[name="employer"]': 'employer'
          'input[name="birthday"]': 'birthday'

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

    initialize: ->
      Backbone.Validation.bind(this)
      @previousAttributes = @model.toJSON()

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
          $(ev.target)
            .parents('form')
            .find('.gc-edit-profile-modal-avatar')
            .attr('src', e.target.result)
        reader.readAsDataURL(input.files[0])

    submitClientForm: (ev) ->
      ev.preventDefault()
      @model.save()

    onSync: (model, response, options) ->
      @previousAttributes = @model.toJSON()
      @trigger 'modal:close'
      @trigger 'addToClientsCollection', model
      if @avatar?[0].files[0]
        data = new FormData()
        data.append('avatar', @avatar[0].files[0])
        @model.updateAvatar(data)

    onAvatarUpdate: (response) ->
      @model.set 'avatar_url', data.avatar_url
      @trigger 'avatarChange'

    onSyncError: (model, response, options) ->
      #todo implement sync error
