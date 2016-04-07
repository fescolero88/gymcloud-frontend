# define [
#   './template'
# ], (
#   template
# ) ->
#   class ProfileEditModalView extends Marionette.ItemView

#     template: template

#     className: 'modal-dialog'

#     behaviors:

#       form_validation: true

#       stickit:
#         bindings:
#           'input[name="gender"]': 'gender'
#           'input[name="weight"]': 'weight'
#           'input[name="height"]': 'height'
#           'input[name="bodyfat"]': 'bodyfat'
#           'input[name="email"]':
#             observe: 'email'
#             onGet: (value) ->
#               value || 'User is not registered yet'
#           'input[name="first_name"]': 'first_name'
#           'input[name="last_name"]': 'last_name'
#           'input[name="location"]': 'location'
#           'input[name="zip"]': 'zip'
#           'input[name="employer"]': 'employer'
#           'input[name="birthday"]': 'birthday'

#     events:
#       'submit @ui.clientForm': 'submitClientForm'
#       'change .gc-edit-profile-modal-upload-input': 'showThumbnail'
#       'blur form input': 'validateInput'
#       'change @ui.avatarInput': 'uploadAvatar'

#     modelEvents:
#       'sync': 'onSync'
#       'error': 'onSyncError'
#       'model:avatar_update:success': 'onAvatarUpdate'

#     ui:
#       clientForm: 'form'
#       avatarInput: 'input[type="file"]'

#     initialize: ->
#       Backbone.Validation.bind(@)
#       @previousAttributes = @model.toJSON()

#     validateInput: (ev) ->
#       $input = $(ev.target)
#       input_name = $(ev.target).attr 'name'
#       input_value = $(ev.target).val()
#       if input_value
#         $inputGroup = $input.closest('.form-group')
#         error_msg = @model.preValidate input_name, input_value
#         @trigger 'switchError', error_msg, $inputGroup

#     showThumbnail: (ev) ->
#       input = ev.target
#       if input.files && input.files[0]
#         reader = new FileReader()
#         reader.onload = (e) ->
#           $(ev.target)
#             .parents('form')
#             .find('.gc-edit-profile-modal-avatar')
#             .attr('src', e.target.result)
#         reader.readAsDataURL(input.files[0])

#     submitClientForm: (ev) ->
#       @model.save()

#     onSync: (model, response, options) ->
#       @previousAttributes = @model.toJSON()
#       @trigger 'modal:close'
#       @trigger 'addToClientsCollection', model
#       if @avatar?[0].files[0]
#         data = new FormData()
#         data.append('avatar', @avatar[0].files[0])
#         @model.updateAvatar(data)

#     onAvatarUpdate: (response) ->
#       @model.set 'avatar_url', data.avatar_url
#       @trigger 'avatarChange'

#     onSyncError: (model, response, options) ->
#       #todo implement sync error

#     uploadAvatar: ->
#       data = new FormData()
#       data.append('avatar', @ui.avatarInput[0].files[0])
#       $.ajax
#         url: "/user_profiles/#{@model.get('id')}/avatar"
#         type: 'PATCH'
#         data: data
#         cache: false
#         processData: false
#         contentType: false
#         dataType: 'json'
#         success: (data) =>
#           @model.set(avatar: data.avatar)
#           profile = App.request('current_user').user_profile
#           profile.set('avatar': data.avatar) if @model.id is profile.id


define [
  './template'
  'features/user_authentications/view'
], (
  template
  UserAuthenticationsView
) ->

  class NewProfileView extends Marionette.LayoutView

    initialize: ->
      Backbone.Validation.bind(@)

    behaviors: ->
      form_validation: true
      facebook_login:
        isSignup: true
        isLinking: true
        successCallback: @successCallback
      google_login:
        isSignup: true
        isLinking: true
        successCallback: @successCallback
      regioned:
        views: [
          region: 'user_authentications'
          klass: UserAuthenticationsView
        ]

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
          '.name': 'full_name'
          '.avatar':
            attributes: [
              name: 'style'
              observe: 'avatar'
              onGet: (ava) ->
                if _.any(ava?.large.url)
                  "background-image: url(#{ava.large.url})"
                else
                  'background-image: url(app/images/logo-big.png)'
              ]
          '.profile-fullfillment, .profile-progress-bar':
            visible: ->
              feature.isEnabled('user_profile_progress')
          '.account-and-payment':
            visible: ->
              feature.isEnabled('user_account_type') and
              feature.isEnabled('payments')
          '.account-type, .control-links .change':
            visible: ->
              feature.isEnabled('user_account_type')
          '.mmmoney, .control-links .history':
            visible: ->
              feature.isEnabled('payments')

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

    successCallback: (json) =>
      @views.user_authentications.trigger('oauthCreated', json)

    onShow: =>
      $('.gc-main').css('padding-left', '0px')
      $('.gc-main').css('padding-right', '0px')
      $.get("/users/#{@model.get('user_id')}").done (user) ->
        $('input[name="email"]').val(user.email)
