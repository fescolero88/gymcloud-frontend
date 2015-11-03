define [
  './template'
], (
  template
) ->
  class NewProfileView extends Marionette.ItemView

    initialize: ->
      Backbone.Validation.bind(@)

    behaviors: ->
      form_validation: true

      stickit:
        bindings:
          'input[name="gender"]': 'gender'
          'input[name="weight"]': 'weight'
          'input[name="height"]': 'height'
          'input[name="bodyfat"]': 'bodyfat'
          'input[name="first_name"]': 'first_name'
          '.name span.first': 'first_name'
          'input[name="last_name"]': 'last_name'
          '.name span.last': 'last_name'
          'input[name="location"]': 'location'
          'input[name="zip"]': 'zip'
          'input[name="employer"]': 'employer'
          'input[name="birthday"]': 'birthday'
          '.avatar':
            attributes: [{
              name: 'style'
              observe: 'avatar'
              onGet: (ava) ->
                return "background-image: url(#{ava.large.url})"
              }]

    className: 'new-profile-view'

    template: template

    ui:
      avatar: '.profile-left-side .avatar'
      submitButton: 'button[type="submit"]'
      avatarInput: 'input[type="file"]'

    events:
      'click @ui.submitButton': -> @model.save()
      'change .upload-avatar': 'showThumbnail'
      'blur input': 'validateInput'
      'change @ui.avatarInput': 'uploadAvatar'

    validateInput: (ev) ->
      $input = $(ev.target)
      input_name = $(ev.target).attr 'name'
      input_value = $(ev.target).val()
      if input_value
        $inputGroup = $input.closest('.form-group')
        error_msg = @model.preValidate input_name, input_value
        @trigger 'switchError', error_msg, $inputGroup

    uploadAvatar: ->
      data = new FormData()
      data.append('avatar', @ui.avatarInput[0].files[0])
      upload = $.ajax
        url: "/user_profiles/#{@model.get('id')}/avatar"
        type: 'PATCH'
        data: data
        cache: false
        dataType: 'file'
        processData: false
        contentType: false
      upload.always =>
        @model.fetch()

    onShow: =>
      $('.gc-main').css('padding-left', '0px')
      $('.gc-main').css('padding-right', '0px')
      $.get("/users/#{@model.get('user_id')}").done (user) ->
        $('input[name="email"]').val(user.email)

    onDestroy: ->
      $('.gc-main').css('padding-left', '15px')
      $('.gc-main').css('padding-right', '15px')
